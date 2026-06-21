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
type EntryLabel = "main" | "aram";

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

function pascalFromSlug(slug: string): string {
  return slug
    .split("_")
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join("");
}

function heroInitFunctionName(slug: string): string {
  return `heroInit${pascalFromSlug(slug)}`;
}

function heroTagFromSlug(slug: string): string {
  switch (slug) {
    case "jetpack_cat":
      return "jetpackCat";
    case "junker_queen":
      return "junkerQueen";
    case "soldier76":
      return "soldier";
    case "wrecking_ball":
      return "wreckingBall";
    default:
      return slug;
  }
}

function heroConstFromSlug(slug: string): string {
  return heroTagFromSlug(slug).replace(/([a-z0-9])([A-Z])/g, "$1_$2").toUpperCase();
}

function normalizeRepoPath(filePath: string): string {
  return path.relative(repoRoot, filePath).split(path.sep).join("/");
}

function validateAllowedIncludes(
  reporter: Reporter,
  label: string,
  includes: string[],
  predicate: (includePath: string) => boolean,
): void {
  const invalid = includes.filter((includePath) => !predicate(includePath));
  if (invalid.length === 0) {
    reporter.pass(`${label} include responsibility preserved`);
  } else {
    reporter.fail(`${label} contains cross-phase includes: ${invalid.join(", ")}`);
  }
}

function classifyEntryPhase(entryLabel: EntryLabel, relPath: string): number | null {
  if (
    relPath === "src/utilities/macros.opy" ||
    relPath.startsWith("src/constants/") ||
    relPath === "src/modules/prelude/settings.opy" ||
    relPath === "src/aram_settings.opy" ||
    relPath === "src/constants/ow2_hero_defaults.opy"
  ) {
    return 0;
  }
  if (
    relPath === "src/modules/prelude/global-vars.opy" ||
    relPath === "src/modules/prelude/player-vars.opy" ||
    relPath === "src/modules/prelude/subroutine.opy"
  ) {
    return 1;
  }
  if (relPath === "src/modules/bootstrap/aram-extra-hero-pool.opy") {
    return 4;
  }
  if (
    relPath === "src/main_mode_profile.opy" ||
    relPath === "src/aram_protocol.opy" ||
    relPath === "src/heroes/settings.opy" ||
    relPath === "src/heroes/settings.aram.opy" ||
    /^src\/heroes\/[^/]+\/settings(\.aram)?\.opy$/.test(relPath) ||
    relPath.startsWith("src/modules/bootstrap/") &&
    relPath !== "src/modules/bootstrap/player-lifecycle-and-reset.opy" &&
    relPath !== "src/modules/bootstrap/aram-player-lifecycle-and-reset.opy"
  ) {
    return 2;
  }
  if (
    relPath.startsWith("src/utilities/") &&
    relPath !== "src/utilities/reset_statuses.opy" &&
    relPath !== "src/utilities/reset_hero.opy" &&
    relPath !== "src/utilities/changelog_text.opy"
  ) {
    return 2;
  }
  if (relPath.startsWith("src/modules/ai/")) {
    return 3;
  }
  if (
    relPath === "src/heroes/main.opy" ||
    relPath === "src/aram_overrides.opy" ||
    relPath === "src/modules/hero_rules/player_shared.opy" ||
    relPath.endsWith("/rules.opy") ||
    /^src\/heroes\/[^/]+\/(?!settings(?:\.aram)?\.opy$|init\.opy$|aram\.opy$).+\.opy$/.test(relPath) ||
    (entryLabel === "aram" && /^src\/heroes\/[^/]+\/aram\.opy$/.test(relPath))
  ) {
    return 4;
  }
  if (
    relPath === "src/utilities/reset_statuses.opy" ||
    relPath === "src/utilities/reset_hero.opy" ||
    relPath === "src/modules/bootstrap/player-lifecycle-and-reset.opy" ||
    relPath === "src/modules/bootstrap/aram-player-lifecycle-and-reset.opy"
  ) {
    return 5;
  }
  if (
    relPath === "src/heroes/aram.opy" ||
    relPath.startsWith("src/modules/hero_init/") ||
    relPath.endsWith("/init.opy")
  ) {
    return 6;
  }
  if (relPath === "src/modules/debug/changelog.opy" || relPath === "src/utilities/changelog_text.opy") {
    return 7;
  }
  return null;
}

function validateExpandedPhaseOrder(
  reporter: Reporter,
  entryLabel: EntryLabel,
  includedFiles: string[],
): void {
  let previousPhase = -1;
  for (const filePath of includedFiles) {
    const relPath = normalizeRepoPath(filePath);
    const phase = classifyEntryPhase(entryLabel, relPath);
    if (phase === null) {
      reporter.fail(`${entryLabel} include graph has unclassified file: ${relPath}`);
      return;
    }
    if (phase < previousPhase) {
      reporter.fail(
        `${entryLabel} expanded include order regressed at ${relPath} (phase=${phase} previous=${previousPhase})`,
      );
      return;
    }
    previousPhase = phase;
  }
  reporter.pass(`${entryLabel} expanded include order preserves entry phases`);
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
    const expectedBefore: string[] = [];
    const mainHeroInitIncludes = [
      "utilities/reset_statuses.opy",
      "utilities/reset_hero.opy",
      "modules/bootstrap/player-lifecycle-and-reset.opy",
      "modules/hero_init/delimiter-begin.opy",
      "modules/hero_init/dispatcher.opy",
      "heroes/reaper/init.opy",
      "heroes/tracer/init.opy",
      "heroes/mercy/init.opy",
      "heroes/hanzo/init.opy",
      "heroes/freja/init.opy",
      "heroes/shion/init.opy",
      "heroes/torbjorn/init.opy",
      "heroes/venture/init.opy",
      "heroes/vendetta/init.opy",
      "heroes/wuyang/init.opy",
      "heroes/reinhardt/init.opy",
      "heroes/hazard/init.opy",
      "heroes/domina/init.opy",
      "heroes/anran/init.opy",
      "heroes/emre/init.opy",
      "heroes/mizuki/init.opy",
      "heroes/jetpack_cat/init.opy",
      "heroes/pharah/init.opy",
      "heroes/winston/init.opy",
      "heroes/widowmaker/init.opy",
      "heroes/bastion/init.opy",
      "heroes/symmetra/init.opy",
      "heroes/zenyatta/init.opy",
      "heroes/genji/init.opy",
      "heroes/roadhog/init.opy",
      "heroes/cassidy/init.opy",
      "heroes/junkrat/init.opy",
      "heroes/zarya/init.opy",
      "heroes/soldier76/init.opy",
      "heroes/lucio/init.opy",
      "heroes/dva/init.opy",
      "heroes/mei/init.opy",
      "heroes/sombra/init.opy",
      "heroes/ana/init.opy",
      "heroes/orisa/init.opy",
      "heroes/brigitte/init.opy",
      "heroes/moira/init.opy",
      "heroes/wrecking_ball/init.opy",
      "heroes/sojourn/init.opy",
      "heroes/ashe/init.opy",
      "heroes/echo/init.opy",
      "heroes/baptiste/init.opy",
      "heroes/kiriko/init.opy",
      "heroes/junker_queen/init.opy",
      "heroes/sierra/init.opy",
      "heroes/sigma/init.opy",
      "heroes/ramattra/init.opy",
      "heroes/juno/init.opy",
      "heroes/doomfist/init.opy",
      "heroes/lifeweaver/init.opy",
      "heroes/mauga/init.opy",
      "heroes/illari/init.opy",
      "modules/hero_init/delimiter-end.opy",
    ];
    const expectedAfter = [
      "utilities/macros.opy",
      "constants/player_constants.opy",
      "modules/prelude/settings.opy",
      "modules/prelude/global-vars.opy",
      "modules/prelude/player-vars.opy",
      "modules/prelude/subroutine.opy",
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
      ...mainHeroInitIncludes,
      "modules/debug/changelog.opy",
      "utilities/changelog_text.opy",
    ];
    const before = mainIncludes.filter((item) => item.line < optimizeLine).map((item) => item.path);
    const after = mainIncludes.filter((item) => item.line > optimizeLine).map((item) => item.path);
    compareArrays(reporter, "main before optimizeStrict", before, expectedBefore);
    compareArrays(reporter, "main after optimizeStrict", after, expectedAfter);
  }

  const aramMainFile = resolveRepo("src/aramMain.opy");
  const aramMainLines = await readLines(aramMainFile);
  const aramMainIncludes = parseIncludes(aramMainLines);
  const aramOptimizeLine = aramMainLines.findIndex((line) => line.includes("#!optimizeStrict")) + 1;

  if (aramOptimizeLine > 0 && aramMainLines.filter((line) => line.includes("#!optimizeStrict")).length === 1) {
    reporter.pass(`aram directive: #!optimizeStrict at line ${aramOptimizeLine}`);
  } else {
    reporter.fail("aram directive missing/duplicated: #!optimizeStrict");
  }

  if (aramOptimizeLine > 0) {
    const expectedBefore: string[] = [];
    const expectedAfter = [
      "utilities/macros.opy",
      "constants/ow2_hero_defaults.opy",
      "constants/player_constants.opy",
      "aram_settings.opy",
      "modules/prelude/global-vars.opy",
      "modules/prelude/player-vars.opy",
      "modules/prelude/subroutine.opy",
      "aram_protocol.opy",
      "modules/bootstrap/aram-mode-settings.opy",
      "modules/bootstrap/aram-hero-ability-settings.opy",
      "modules/bootstrap/aram-safety-blacklist-ban.opy",
      "utilities/bot_aim2target.opy",
      "utilities/clear_custom_hp.opy",
      "utilities/enable_all_abilities.opy",
      "utilities/reset_frenemies.opy",
      "utilities/hero_switch.opy",
      "utilities/disable_all_abilities.opy",
      "utilities/reset_stats.opy",
      "utilities/knockback.opy",
      "utilities/set_third_person.opy",
      "utilities/remove_tank_passive.opy",
      "modules/bootstrap/blacklist.opy",
      "modules/ai/delimiter-begin.opy",
      "modules/ai/core/core-global-and-targeting.opy",
      "modules/ai/movement/movement.opy",
      "modules/ai/control/common.opy",
      "modules/ai/control/heroes.opy",
      "modules/ai/delimiter-end.opy",
      "aram_overrides.opy",
      "utilities/reset_statuses.opy",
      "utilities/reset_hero.opy",
      "modules/bootstrap/aram-player-lifecycle-and-reset.opy",
      "heroes/aram.opy",
      "modules/debug/changelog.opy",
      "utilities/changelog_text.opy",
    ];
    const before = aramMainIncludes.filter((item) => item.line < aramOptimizeLine).map((item) => item.path);
    const after = aramMainIncludes.filter((item) => item.line > aramOptimizeLine).map((item) => item.path);
    compareArrays(reporter, "aram before optimizeStrict", before, expectedBefore);
    compareArrays(reporter, "aram after optimizeStrict", after, expectedAfter);
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
  const heroesMainIncludes = parseIncludes(heroesMainLines).map((item) => item.path);
  validateAllowedIncludes(
    reporter,
    "src/heroes/main.opy",
    heroesMainIncludes,
    (includePath) => includePath === "../modules/hero_rules/player_shared.opy" || /^(?!\.\.\/).+\/rules\.opy$/.test(includePath),
  );

  const heroesAramFile = resolveRepo("src/heroes/aram.opy");
  const heroesAramLines = await readLines(heroesAramFile);
  const heroesAramIncludes = parseIncludes(heroesAramLines).map((item) => item.path);
  const aramInitSequence = ["../modules/hero_init/dispatcher.opy"];
  if (aramInitSequence.every((entry, index) => heroesAramIncludes[index] === entry)) {
    reporter.pass("src/heroes/aram.opy hero init dispatcher order preserved");
  } else {
    reporter.fail("src/heroes/aram.opy hero init dispatcher order is broken");
  }
  if (heroesAramIncludes.length > aramInitSequence.length) {
    reporter.pass("src/heroes/aram.opy includes hero init files");
  } else {
    reporter.fail("src/heroes/aram.opy is missing hero init includes");
  }

  const aramOverridesFile = resolveRepo("src/aram_overrides.opy");
  const aramOverridesLines = await readLines(aramOverridesFile);
  const aramOverridesIncludes = parseIncludes(aramOverridesLines).map((item) => item.path);
  validateAllowedIncludes(
    reporter,
    "src/aram_overrides.opy",
    aramOverridesIncludes,
    (includePath) =>
      includePath === "modules/bootstrap/aram-extra-hero-pool.opy" ||
      /^heroes\/[^/]+\/aram\.opy$/.test(includePath) ||
      /^heroes\/[^/]+\/rules\.opy$/.test(includePath),
  );

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

  const heroInitDispatcherFile = resolveRepo("src/modules/hero_init/dispatcher.opy");
  const heroInitDispatcherLines = await readLines(heroInitDispatcherFile);
  const heroInitSubroutines = extractDeclarationsFromLines(heroInitDispatcherLines, "subroutine");
  const dispatcherInitRuleCount = countExactRuleName(heroInitDispatcherLines, "[hero_init/dispatcher.opy]: initialize hero");
  const dispatcherDispatchDefCount = heroInitDispatcherLines.filter((line) => line === "def heroInitDispatcher():").length;
  const dispatcherResetLine = heroInitDispatcherLines.findIndex((line) => line.includes("resetHero()"));
  const dispatcherClearLine = heroInitDispatcherLines.findIndex((line) => line.includes("eventPlayer._reset_requested = false"));
  const dispatcherPendingClearCount = heroInitDispatcherLines.filter((line) => line.includes("eventPlayer.call_init = false")).length;
  const dispatcherLastHeroCount = heroInitDispatcherLines.filter((line) => line.includes("eventPlayer._last_hero_played = eventPlayer.init_hero")).length;
  const dispatcherQueueGateCount = heroInitDispatcherLines.filter((line) => line.includes("@Condition eventPlayer.call_init == true")).length;
  const dispatcherSpawnGateCount = heroInitDispatcherLines.filter((line) => line.includes("@Condition eventPlayer.hasSpawned() == true")).length;
  const dispatcherResetGateCount = heroInitDispatcherLines.filter((line) => line.includes("@Condition eventPlayer._reset_requested != false")).length;
  const dispatcherHeroMatchGateCount = heroInitDispatcherLines.filter((line) =>
    line.includes("@Condition eventPlayer.getCurrentHero() == eventPlayer.init_hero"),
  ).length;

  if (heroInitSubroutines.filter((name) => name === "heroInitDispatcher").length === 1) {
    reporter.pass("hero init subroutine declarations include heroInitDispatcher exactly once");
  } else {
    reporter.fail("hero init subroutine declarations should include heroInitDispatcher exactly once");
  }
  if (dispatcherDispatchDefCount === 1) {
    reporter.pass("hero init dispatcher file defines heroInitDispatcher exactly once");
  } else {
    reporter.fail(`hero init dispatcher file should define heroInitDispatcher exactly once (count=${dispatcherDispatchDefCount})`);
  }
  if (dispatcherInitRuleCount === 1) {
    reporter.pass("hero init dispatcher file defines one initialize rule");
  } else {
    reporter.fail(`hero init dispatcher file should define one initialize rule (count=${dispatcherInitRuleCount})`);
  }
  if (dispatcherQueueGateCount === 1 && dispatcherSpawnGateCount === 1 && dispatcherResetGateCount === 1 && dispatcherHeroMatchGateCount === 1) {
    reporter.pass("hero init dispatcher initialize rule gate contract preserved");
  } else {
    reporter.fail("hero init dispatcher initialize rule gating contract is broken");
  }
  if (dispatcherPendingClearCount === 1 && dispatcherLastHeroCount === 1) {
    reporter.pass("hero init dispatcher initialize rule clears pending state and updates last hero");
  } else {
    reporter.fail("hero init dispatcher initialize rule missing pending clear or last hero update");
  }
  if (dispatcherResetLine >= 0 && dispatcherClearLine > dispatcherResetLine) {
    reporter.pass("hero init dispatcher initialize rule clears reset flag after resetHero()");
  } else {
    reporter.fail("hero init dispatcher initialize rule must clear _reset_requested after resetHero()");
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

  for (const entryRoot of entryRoots) {
    const includedFiles = (includedFilesByEntry.get(entryRoot.label) ?? []).slice(1);
    validateExpandedPhaseOrder(reporter, entryRoot.label, includedFiles);
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

    const initLines = await readLines(initFile);
    const expectedDefName = heroInitFunctionName(heroName);
    const expectedHeroConst = heroConstFromSlug(heroName);
    const defCount = initLines.filter((line) => line === `def ${expectedDefName}():`).length;
    const ruleCount = initLines.filter((line) => line.startsWith('rule "')).length;
    const trueCount = initLines.filter((line) => line.includes("eventPlayer._reset_requested = true")).length;
    const falseCount = initLines.filter((line) => line.includes("eventPlayer._reset_requested = false")).length;
    const resetHeroCount = initLines.filter((line) => line.includes("resetHero()")).length;
    const condCount = initLines.filter(
      (line) =>
        line.includes("@Condition eventPlayer._reset_requested != false") ||
        line.includes("@Condition eventPlayer._reset_requested == true"),
    ).length;
    const localDetectMacroCount = initLines.filter((line) => line.includes("shouldDetectHeroInit(")).length;
    const dispatcherConditionCount = heroInitDispatcherLines.filter((line) => line.includes(`case Hero.${expectedHeroConst}:`)).length;
    const dispatcherCallCount = heroInitDispatcherLines.filter((line) => line.includes(`${expectedDefName}()`)).length;

    if (defCount === 1) {
      reporter.pass(`${heroName}.init defines ${expectedDefName} exactly once`);
    } else {
      reporter.fail(`${heroName}.init should define ${expectedDefName} exactly once (count=${defCount})`);
    }
    if (ruleCount === 0) {
      reporter.pass(`${heroName}.init no longer carries local Detect/Initialize rules`);
    } else {
      reporter.fail(`${heroName}.init should not keep local hero init rules (rule count=${ruleCount})`);
    }
    if (trueCount === 0) {
      reporter.pass(`${heroName}.init no longer queues _reset_requested locally`);
    } else {
      reporter.fail(`${heroName}.init should not set _reset_requested = true locally`);
    }
    if (falseCount === 0) {
      reporter.pass(`${heroName}.init no longer clears _reset_requested locally`);
    } else {
      reporter.fail(`${heroName}.init should not clear _reset_requested locally`);
    }
    if (resetHeroCount === 0) {
      reporter.pass(`${heroName}.init no longer calls resetHero() locally`);
    } else {
      reporter.fail(`${heroName}.init should not call resetHero() locally`);
    }
    if (condCount === 0) {
      reporter.pass(`${heroName}.init no longer carries local _reset_requested gating`);
    } else if (args.strictHeroInit) {
      reporter.fail(`${heroName}.init should not carry local _reset_requested gating`);
    } else {
      reporter.warn(`${heroName}.init still carries local _reset_requested gating`);
    }
    if (localDetectMacroCount === 0) {
      reporter.pass(`${heroName}.init no longer references shouldDetectHeroInit()`);
    } else {
      reporter.fail(`${heroName}.init should not reference shouldDetectHeroInit() anymore`);
    }
    if (heroInitSubroutines.filter((name) => name === expectedDefName).length === 1) {
      reporter.pass(`hero init subroutine declarations include ${expectedDefName}`);
    } else {
      reporter.fail(`hero init subroutine declarations missing/duplicated for ${expectedDefName}`);
    }
    if (dispatcherConditionCount === 1 && dispatcherCallCount >= 1) {
      reporter.pass(`${heroName}.init is wired into the hero init dispatcher`);
    } else {
      reporter.fail(`${heroName}.init missing dispatcher route for Hero.${expectedHeroConst}`);
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
