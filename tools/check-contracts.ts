#!/usr/bin/env -S node --import tsx

import fs from "node:fs/promises";
import path from "node:path";
import { Reporter } from "./lib/report.js";
import { readLines, repoRoot, resolveRepo, runCommand } from "./lib/runtime.js";

type Args = {
  strictHeroInit: boolean;
  runBuild: boolean;
};

type DeclarationKind = "globalvar" | "playervar" | "subroutine";

function usage(): void {
  console.log("Usage: tools/check-contracts.ts [--strict-hero-init] [--build]");
}

function parseArgs(argv: string[]): Args {
  const args: Args = { strictHeroInit: false, runBuild: false };
  for (const arg of argv) {
    switch (arg) {
      case "--strict-hero-init":
        args.strictHeroInit = true;
        break;
      case "--build":
        args.runBuild = true;
        break;
      case "-h":
      case "--help":
        usage();
        process.exit(0);
      default:
        throw new Error(`Unknown argument: ${arg}`);
    }
  }
  return args;
}

function compareArrays(reporter: Reporter, label: string, actual: string[], expected: string[]): void {
  if (actual.length !== expected.length) {
    reporter.fail(`${label} include count mismatch (actual=${actual.length} expected=${expected.length})`);
    return;
  }
  for (let index = 0; index < expected.length; index += 1) {
    if (actual[index] !== expected[index]) {
      reporter.fail(
        `${label} include mismatch at position ${index + 1}: actual=${actual[index]} expected=${expected[index]}`,
      );
      return;
    }
  }
  reporter.pass(`${label} include order contract preserved`);
}

function parseIncludes(lines: string[]): Array<{ line: number; path: string }> {
  const includes: Array<{ line: number; path: string }> = [];
  for (let index = 0; index < lines.length; index += 1) {
    const match = lines[index]!.match(/^\s*#!include\s+"([^"]+)"/);
    if (match) {
      includes.push({ line: index + 1, path: match[1]! });
    }
  }
  return includes;
}

function countExactRuleName(lines: string[], name: string): number {
  return lines.filter((line) => line === `rule "${name}":`).length;
}

async function parseProtocolMapping(filePath: string): Promise<Array<{ kind: string; name: string; index: number }>> {
  const lines = (await fs.readFile(filePath, "utf8")).split(/\r?\n/);
  return lines
    .map((line) => line.trim())
    .filter(Boolean)
    .map((line) => {
      const [kind, name, index] = line.split("\t");
      return { kind: kind!, name: name!, index: Number(index) };
    });
}

async function extractDeclarations(
  filePath: string,
  kind: DeclarationKind,
): Promise<string[]> {
  const lines = await readLines(filePath);
  return lines
    .map((line) => line.match(new RegExp(`^${kind}\\s+([^\\s]+)`))?.[1] ?? null)
    .filter((value): value is string => Boolean(value));
}

function extractDeclarationsFromLines(
  lines: string[],
  kind: DeclarationKind,
): string[] {
  return lines
    .map((line) => line.match(new RegExp(`^${kind}\\s+([^\\s]+)`))?.[1] ?? null)
    .filter((value): value is string => Boolean(value));
}

async function collectIncludedFiles(entryFile: string): Promise<string[]> {
  const visited = new Set<string>();
  const ordered: string[] = [];

  async function visit(filePath: string): Promise<void> {
    const resolved = path.resolve(filePath);
    if (visited.has(resolved)) {
      return;
    }
    visited.add(resolved);
    ordered.push(resolved);

    const lines = await readLines(resolved);
    for (const include of parseIncludes(lines)) {
      await visit(path.resolve(path.dirname(resolved), include.path));
    }
  }

  await visit(entryFile);
  return ordered;
}

function findEntryDuplicates(
  declarations: Array<{ filePath: string; name: string }>,
): Array<{ name: string; files: string[] }> {
  const byName = new Map<string, Set<string>>();
  for (const declaration of declarations) {
    if (!byName.has(declaration.name)) {
      byName.set(declaration.name, new Set<string>());
    }
    byName.get(declaration.name)!.add(path.relative(repoRoot, declaration.filePath));
  }

  return [...byName.entries()]
    .filter(([, files]) => files.size > 1)
    .map(([name, files]) => ({ name, files: [...files].sort((a, b) => a.localeCompare(b)) }))
    .sort((a, b) => a.name.localeCompare(b.name));
}

function inspectMainFileDirective(lines: string[]): { count: number; target: string | null; isFirstLine: boolean } {
  const matches = lines
    .map((line) => line.match(/^\s*#!mainFile\s+"([^"]+)"\s*$/)?.[1] ?? null)
    .filter((value): value is string => value !== null);

  return {
    count: matches.length,
    target: matches[0] ?? null,
    isFirstLine: /^\s*#!mainFile\s+"[^"]+"\s*$/.test(lines[0] ?? ""),
  };
}

function toDirectivePath(filePath: string, targetFile: string): string {
  return path.relative(path.dirname(filePath), targetFile).split(path.sep).join("/");
}

function duplicateNames(values: string[]): string[] {
  const seen = new Set<string>();
  const dupes = new Set<string>();
  for (const value of values) {
    if (seen.has(value)) {
      dupes.add(value);
    }
    seen.add(value);
  }
  return [...dupes].sort((a, b) => a.localeCompare(b));
}

async function main(): Promise<void> {
  const args = parseArgs(process.argv.slice(2));
  const reporter = new Reporter();
  console.log(`Running ow-contract-guard checks from: ${repoRoot}`);

  const mainFile = resolveRepo("src/main.opy");
  const mainLines = await readLines(mainFile);
  const mainIncludes = parseIncludes(mainLines);
  const optimizeLine = mainLines.findIndex((line) => line.includes("#!optimizeStrict")) + 1;

  const indexRefCount = mainIncludes.filter((item) => item.path.endsWith("/_index.opy")).length;
  if (indexRefCount === 0) {
    reporter.pass("main includes are flattened (no *_index.opy references)");
  } else {
    reporter.fail(`main still references *_index.opy includes (count=${indexRefCount})`);
  }

  if (optimizeLine > 0 && mainLines.filter((line) => line.includes("#!optimizeStrict")).length === 1) {
    reporter.pass(`main directive: #!optimizeStrict at line ${optimizeLine}`);
  } else {
    reporter.fail("main directive missing/duplicated: #!optimizeStrict");
  }

  if (optimizeLine > 0) {
    const expectedBefore = [
      "utilities/macros.opy",
      "constants/player_constants.opy",
      "modules/prelude/settings.opy",
      "modules/prelude/global-vars.opy",
      "modules/prelude/player-vars.opy",
      "modules/prelude/subroutine.opy",
    ];
    const expectedAfter = [
      "modules/bootstrap/init-and-settings.opy",
      "modules/bootstrap/anti-crash.opy",
      "modules/bootstrap/blacklist.opy",
      "modules/bootstrap/safety-blacklist-ban.opy",
      "main_mode_profile.opy",
      "utilities/knockback.opy",
      "utilities/apply_custom_hp.opy",
      "utilities/clear_custom_hp.opy",
      "utilities/reset_frenemies.opy",
      "utilities/hero_switch.opy",
      "utilities/reset_stats.opy",
      "utilities/execute_uppercut.opy",
      "utilities/enable_all_abilities.opy",
      "utilities/disable_all_abilities.opy",
      "utilities/remove_tank_passive.opy",
      "utilities/bot_aim2target.opy",
      "modules/ai/delimiter-begin.opy",
      "modules/ai/core/core-global-and-targeting.opy",
      "modules/ai/movement/movement.opy",
      "modules/ai/control/common.opy",
      "modules/ai/control/heroes.opy",
      "modules/ai/delimiter-end.opy",
      "heroes/main.opy",
      "modules/debug/changelog.opy",
    ];
    const before = mainIncludes.filter((item) => item.line < optimizeLine).map((item) => item.path);
    const after = mainIncludes.filter((item) => item.line > optimizeLine).map((item) => item.path);
    compareArrays(reporter, "main before optimizeStrict", before, expectedBefore);
    compareArrays(reporter, "main after optimizeStrict", after, expectedAfter);
  }

  const aiIndexFile = resolveRepo("src/modules/ai/_index.opy");
  const aiLines = await readLines(aiIndexFile);
  const aiFirst = aiLines.find((line) => line.trim().length > 0) ?? "";
  const aiLast = [...aiLines].reverse().find((line) => line.trim().length > 0) ?? "";
  if (aiFirst === '#!include "delimiter-begin.opy"' && aiLast === '#!include "delimiter-end.opy"') {
    reporter.pass("AI delimiter includes are at the beginning/end of ai/_index.opy");
  } else {
    reporter.fail("AI delimiter include boundaries are broken in ai/_index.opy");
  }

  const heroesMainFile = resolveRepo("src/heroes/main.opy");
  const heroesMainLines = await readLines(heroesMainFile);
  const beginLine = heroesMainLines.findIndex((line) => line.includes('../modules/hero_init/delimiter-begin.opy')) + 1;
  const endLine = heroesMainLines.findIndex((line) => line.includes('../modules/hero_init/delimiter-end.opy')) + 1;
  if (beginLine > 0 && endLine > 0 && beginLine < endLine) {
    reporter.pass("Hero init delimiter includes are ordered in src/heroes/main.opy");
  } else {
    reporter.fail("Hero init delimiter include boundaries are broken in src/heroes/main.opy");
  }

  const heroesMainIncludes = parseIncludes(heroesMainLines).map((item) => item.path);
  const heroResetSequence = [
    "../utilities/reset_statuses.opy",
    "../utilities/reset_hero.opy",
    "../modules/bootstrap/player-lifecycle-and-reset.opy",
    "../modules/hero_init/delimiter-begin.opy",
  ];
  const heroResetStart = heroesMainIncludes.indexOf(heroResetSequence[0]!);
  if (
    heroResetStart >= 0 &&
    heroResetSequence.every((entry, index) => heroesMainIncludes[heroResetStart + index] === entry)
  ) {
    reporter.pass("heroes/main reset late-binding order preserved");
  } else {
    reporter.fail("heroes/main reset late-binding order is broken");
  }

  const heroesAramFile = resolveRepo("src/heroes/aram.opy");
  const heroesAramLines = await readLines(heroesAramFile);
  const heroesAramIncludes = parseIncludes(heroesAramLines).map((item) => item.path);
  if (heroesAramIncludes.length > 0) {
    reporter.pass("src/heroes/aram.opy includes hero init files");
  } else {
    reporter.fail("src/heroes/aram.opy is missing hero init includes");
  }

  const aramOverridesFile = resolveRepo("src/aram_overrides.opy");
  const aramOverridesLines = await readLines(aramOverridesFile);
  const aramOverridesIncludes = parseIncludes(aramOverridesLines).map((item) => item.path);
  const aramResetSequence = [
    "utilities/reset_statuses.opy",
    "utilities/reset_hero.opy",
    "modules/bootstrap/aram-player-lifecycle-and-reset.opy",
  ];
  const aramResetStart = aramOverridesIncludes.indexOf(aramResetSequence[0]!);
  if (
    aramResetStart >= 0 &&
    aramResetSequence.every((entry, index) => aramOverridesIncludes[aramResetStart + index] === entry)
  ) {
    reporter.pass("aram_overrides reset late-binding order preserved");
  } else {
    reporter.fail("aram_overrides reset late-binding order is broken");
  }

  const srcLines = (await fs.readFile(resolveRepo("src"), "utf8").catch(() => "")).split(/\r?\n/);
  const allOpyFiles: string[] = [];
  async function walk(current: string): Promise<void> {
    const entries = await fs.readdir(current, { withFileTypes: true });
    for (const entry of entries) {
      const next = path.join(current, entry.name);
      if (entry.isDirectory()) {
        await walk(next);
      } else if (entry.name.endsWith(".opy")) {
        allOpyFiles.push(next);
      }
    }
  }
  await walk(resolveRepo("src"));
  const requiredDelimiters = [
    "Initialize AI Scripts",
    "Initialize AI Scripts End",
    "Initialize Heroes",
    "Initialize Heors End",
  ];
  const mergedLines = (
    await Promise.all(allOpyFiles.map(async (filePath) => fs.readFile(filePath, "utf8")))
  ).join("\n");
  for (const name of requiredDelimiters) {
    const count = countExactRuleName(mergedLines.split(/\r?\n/), name);
    if (count === 1) {
      reporter.pass(`delimiter rule exists exactly once: ${name}`);
    } else {
      reporter.fail(`delimiter rule missing/duplicated: ${name} (count=${count})`);
    }
  }

  const protocolFile = resolveRepo("tools/data/contract-guard/protocol-indexes.tsv");
  const protocolMappings = await parseProtocolMapping(protocolFile);
  reporter.pass(`protocol index reference file found`);

  const declarationFiles = {
    globalvar: resolveRepo("src/modules/prelude/global-vars.opy"),
    playervar: resolveRepo("src/modules/prelude/player-vars.opy"),
    subroutine: resolveRepo("src/modules/prelude/subroutine.opy"),
  } as const;

  for (const kind of ["globalvar", "playervar", "subroutine"] as const) {
    const declarations = await extractDeclarations(declarationFiles[kind], kind);
    const dupes = duplicateNames(declarations);
    if (dupes.length > 0) {
      reporter.fail(`${kind} has duplicate names in ${path.relative(repoRoot, declarationFiles[kind])}: ${dupes.join(" ")}`);
    } else {
      reporter.pass(`${kind} has no duplicate names in ${path.relative(repoRoot, declarationFiles[kind])}`);
    }
  }

  const entryRoots = [
    { label: "main", filePath: resolveRepo("src/main.opy") },
    { label: "aram", filePath: resolveRepo("src/aramMain.opy") },
  ] as const;
  const includedFilesByEntry = new Map<string, string[]>();

  for (const entryRoot of entryRoots) {
    includedFilesByEntry.set(entryRoot.label, await collectIncludedFiles(entryRoot.filePath));
  }

  const moduleOwners = new Map<string, Set<string>>();
  for (const entryRoot of entryRoots) {
    for (const filePath of includedFilesByEntry.get(entryRoot.label) ?? []) {
      const resolved = path.resolve(filePath);
      if (resolved === path.resolve(entryRoot.filePath)) {
        continue;
      }
      if (!moduleOwners.has(resolved)) {
        moduleOwners.set(resolved, new Set<string>());
      }
      moduleOwners.get(resolved)!.add(entryRoot.label);
    }
  }

  for (const [filePath, owners] of [...moduleOwners.entries()].sort((a, b) => a[0].localeCompare(b[0]))) {
    const lines = await readLines(filePath);
    const directive = inspectMainFileDirective(lines);
    const expectedTarget = owners.size === 1 && owners.has("aram")
      ? toDirectivePath(filePath, resolveRepo("src/aramMain.opy"))
      : toDirectivePath(filePath, resolveRepo("src/main.opy"));
    const relPath = path.relative(repoRoot, filePath);

    if (directive.count !== 1) {
      reporter.fail(`module mainFile count invalid: ${relPath} (count=${directive.count})`);
      continue;
    }
    if (!directive.isFirstLine) {
      reporter.fail(`module mainFile must be first line: ${relPath}`);
      continue;
    }
    if (directive.target !== expectedTarget) {
      reporter.fail(
        `module mainFile target mismatch: ${relPath} (actual=${directive.target} expected=${expectedTarget})`,
      );
      continue;
    }
    reporter.pass(`module mainFile contract preserved: ${relPath}`);
  }

  for (const entryRoot of entryRoots) {
    const includedFiles = includedFilesByEntry.get(entryRoot.label) ?? [];
    for (const kind of ["globalvar", "playervar", "subroutine"] as const) {
      const declarations: Array<{ filePath: string; name: string }> = [];
      for (const filePath of includedFiles) {
        const lines = await readLines(filePath);
        for (const name of extractDeclarationsFromLines(lines, kind)) {
          declarations.push({ filePath, name });
        }
      }

      const duplicates = findEntryDuplicates(declarations);
      if (duplicates.length === 0) {
        reporter.pass(`${entryRoot.label} ${kind} declarations are unique across the entry include graph`);
      } else {
        const detail = duplicates.map((item) => `${item.name} (${item.files.join(", ")})`).join("; ");
        reporter.fail(`${entryRoot.label} ${kind} duplicate declarations found: ${detail}`);
      }
    }
  }

  for (const mapping of protocolMappings) {
    const filePath = declarationFiles[mapping.kind as keyof typeof declarationFiles];
    if (!filePath) {
      reporter.fail(`unknown kind in protocol file: ${mapping.kind}`);
      continue;
    }
    const declarations = await extractDeclarations(filePath, mapping.kind as keyof typeof declarationFiles);
    if (declarations[mapping.index] === mapping.name) {
      reporter.pass(`declaration order preserved: ${mapping.kind} ${mapping.name} ${mapping.index}`);
    } else {
      reporter.fail(`declaration order changed/missing: ${mapping.kind} ${mapping.name} ${mapping.index}`);
    }
  }

  const resetLines = await readLines(resolveRepo("src/utilities/reset_frenemies.opy"));
  const stableSlotMembers = new Map<number, string>([
    [1, "_friendly_brigitte_reference"],
    [3, "_friendly_kiriko_reference"],
    [4, "_friendly_sombra_reference"],
    [5, "_enemy_ramattra_reference"],
    [6, "_enemy_sombra_reference"],
    [7, "_enemy_ana_reference"],
    [8, "_enemy_anran_reference"],
    [9, "_enemy_hanzo_reference"],
    [11, "_enemy_freja_reference"],
    [12, "_friendly_baptiste_reference"],
    [13, "_friendly_wuyang_reference"],
    [14, "_enemy_wuyang_reference"],
    [15, "_team_front_anchor"],
    [16, "_team_back_anchor"],
  ]);
  for (const [slot, member] of stableSlotMembers.entries()) {
    const count = resetLines.filter((line) => line.includes(`eventPlayer.${member} =`)).length;
    if (count === 1) {
      reporter.pass(`reset slot mapping present once: reset_pvar[${slot}]`);
    } else {
      reporter.fail(`reset slot mapping broken for reset_pvar[${slot}] (count=${count})`);
    }
  }

  const heroDirs = await fs.readdir(resolveRepo("src/heroes"), { withFileTypes: true });
  for (const heroDir of heroDirs) {
    if (!heroDir.isDirectory()) {
      continue;
    }
    const heroName = heroDir.name;
    const initFile = resolveRepo("src/heroes", heroName, "init.opy");
    try {
      await fs.access(initFile);
    } catch {
      continue;
    }

    const detectFile = resolveRepo("src/heroes", heroName, "init-detect.opy");
    const sourceFiles = [initFile];
    try {
      await fs.access(detectFile);
      sourceFiles.push(detectFile);
      const initLines = await readLines(initFile);
      const detectIncludeCount = initLines.filter((line) => line.includes('#!include "init-detect.opy"')).length;
      if (detectIncludeCount === 1) {
        reporter.pass(`${heroName}.init includes init-detect.opy exactly once`);
      } else {
        reporter.fail(`${heroName}.init should include init-detect.opy exactly once (count=${detectIncludeCount})`);
      }
    } catch {
      // no detect file
    }

    let ruleCount = 0;
    let trueCount = 0;
    let falseCount = 0;
    let resetHeroCount = 0;
    let condCount = 0;
    for (const sourceFile of sourceFiles) {
      const lines = await readLines(sourceFile);
      ruleCount += lines.filter((line) => line.startsWith('rule "')).length;
      trueCount += lines.filter((line) => line.includes("eventPlayer._reset_requested = true")).length;
      falseCount += lines.filter((line) => line.includes("eventPlayer._reset_requested = false")).length;
      resetHeroCount += lines.filter((line) => line.includes("resetHero()")).length;
      condCount += lines.filter(
        (line) =>
          line.includes("@Condition eventPlayer._reset_requested != false") ||
          line.includes("@Condition eventPlayer._reset_requested == true"),
      ).length;
    }

    if (ruleCount >= 2) {
      reporter.pass(`${heroName}.init has at least two rules`);
    } else {
      reporter.fail(`${heroName}.init should include Detect + Initialize rules (rule count=${ruleCount})`);
    }
    if (trueCount >= 1) {
      reporter.pass(`${heroName}.init sets _reset_requested = true`);
    } else {
      reporter.fail(`${heroName}.init missing _reset_requested = true trigger`);
    }
    if (falseCount >= 1) {
      reporter.pass(`${heroName}.init resets _reset_requested = false`);
    } else {
      reporter.fail(`${heroName}.init missing _reset_requested = false reset`);
    }
    if (resetHeroCount >= 1) {
      reporter.pass(`${heroName}.init calls resetHero() in initialization`);
    } else {
      reporter.fail(`${heroName}.init missing resetHero() call`);
    }
    if (condCount >= 1) {
      reporter.pass(`${heroName}.init gates initialize rule with _reset_requested condition`);
    } else if (args.strictHeroInit) {
      reporter.fail(`${heroName}.init missing initialize gating condition on _reset_requested`);
    } else {
      reporter.warn(`${heroName}.init missing initialize gating condition on _reset_requested`);
    }
  }

  if (args.runBuild) {
    console.log("Running build gate: pnpm run build");
    try {
      runCommand("pnpm", ["run", "build"]);
      reporter.pass("build succeeded");
    } catch {
      reporter.fail("build failed");
    }
  }

  reporter.summary();
  process.exit(reporter.exitCode());
}

main().catch((error: Error) => {
  console.error(error.message);
  process.exit(1);
});
