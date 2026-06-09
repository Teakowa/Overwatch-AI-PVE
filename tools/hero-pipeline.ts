#!/usr/bin/env -S node --import tsx

import fs from "node:fs/promises";
import path from "node:path";
import process from "node:process";
import { spawnSync } from "node:child_process";
import { Reporter } from "./lib/report.js";
import { gitDiffNameOnly, readLines, repoRoot, resolveRepo, runCommand, tryCommand } from "./lib/runtime.js";

type Args = {
  requestHeroes: string[];
  useFromDiff: boolean;
  diffRange: string;
  runBuild: boolean;
  strictChangelog: boolean;
  strictRules: boolean;
  strictInitGate: boolean;
  strictThrottle: boolean;
  strictCooldownPlacement: boolean;
  listHeroes: boolean;
  reportTemplate: boolean;
  reportPath: string | null;
};

function usage(): void {
  console.log("Usage: tools/hero-pipeline.ts [--hero <slug>]... [--from-diff [range]] [--build]");
}

function parseArgs(argv: string[]): Args {
  const args: Args = {
    requestHeroes: [],
    useFromDiff: false,
    diffRange: "HEAD",
    runBuild: false,
    strictChangelog: false,
    strictRules: false,
    strictInitGate: false,
    strictThrottle: false,
    strictCooldownPlacement: false,
    listHeroes: false,
    reportTemplate: false,
    reportPath: null,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index]!;
    switch (arg) {
      case "--hero":
        args.requestHeroes.push(argv[++index] ?? "");
        break;
      case "--from-diff":
        args.useFromDiff = true;
        if (argv[index + 1] && !argv[index + 1]!.startsWith("--")) {
          args.diffRange = argv[++index]!;
        }
        break;
      case "--build":
        args.runBuild = true;
        break;
      case "--strict-changelog":
        args.strictChangelog = true;
        break;
      case "--strict-rules":
        args.strictRules = true;
        break;
      case "--strict-init-gate":
        args.strictInitGate = true;
        break;
      case "--strict-throttle":
        args.strictThrottle = true;
        break;
      case "--strict-cooldown-placement":
        args.strictCooldownPlacement = true;
        break;
      case "--report-template":
        args.reportTemplate = true;
        if (argv[index + 1] && !argv[index + 1]!.startsWith("--")) {
          args.reportPath = argv[++index]!;
        }
        break;
      case "--list-heroes":
        args.listHeroes = true;
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

function listAllHeroesSync(): string[] {
  return tryCommand("find", [resolveRepo("src/heroes"), "-name", "init.opy"], repoRoot)
    .split("\n")
    .filter(Boolean)
    .map((line) => line.match(/src\/heroes\/([^/]+)\/init\.opy$/)?.[1] ?? "")
    .filter(Boolean)
    .sort((a, b) => a.localeCompare(b));
}

function normalizeConstFromTag(tag: string): string {
  const upper = tag.replace(/([a-z0-9])([A-Z])/g, "$1_$2").toUpperCase();
  if (upper === "SOLDIER76") {
    return "SOLDIER";
  }
  return upper;
}

function expectedOwnerForSlot(slot: number): string {
  return (
    {
      1: "brigitte",
      3: "kiriko",
      4: "sombra",
      5: "ramattra",
      7: "ana",
      11: "freja",
    }[slot] ?? ""
  );
}

function expectedTeamForSlot(slot: number): string {
  return ({ 1: "ally", 2: "ally", 3: "ally", 4: "ally", 5: "enemy", 7: "enemy", 11: "enemy" }[slot] ?? "");
}

function collectHeroesFromDiff(range: string): string[] {
  return gitDiffNameOnly(range, ["src/heroes"])
    .map((filePath) => filePath.match(/^src\/heroes\/([^/]+)\/.+\.opy$/)?.[1] ?? "")
    .filter(Boolean)
    .filter((slug, index, values) => values.indexOf(slug) === index)
    .filter((slug) => spawnSync("test", ["-f", resolveRepo("src/heroes", slug, "init.opy")]).status === 0)
    .sort((a, b) => a.localeCompare(b));
}

function countOccurrences(lines: string[], needle: string): number {
  return lines.filter((line) => line.includes(needle)).length;
}

function firstMatchLine(lines: string[], needle: string): number | null {
  const index = lines.findIndex((line) => line.includes(needle));
  return index >= 0 ? index + 1 : null;
}

async function heroSettingsKeyPresentForBothTeams(heroKey: string, key: string): Promise<boolean> {
  const settingsLines = await readLines(resolveRepo("src/modules/prelude/settings.opy"));
  let count = 0;
  for (let index = 0; index < settingsLines.length; index += 1) {
    if (settingsLines[index]!.includes(`"${heroKey}"`) && settingsLines[index]!.includes("{")) {
      const block = settingsLines.slice(index, index + 25).join("\n");
      if (block.includes(`"${key}"`)) {
        count += 1;
      }
    }
  }
  return count >= 2;
}

async function auditCooldownPlacement(
  reporter: Reporter,
  slug: string,
  heroKey: string,
  files: string[],
  strict: boolean,
): Promise<void> {
  if (files.length === 0) {
    reporter.warn(`[cooldown] no hero_rules files found for ${slug}, skip cooldown placement audit`);
    return;
  }
  let checked = 0;
  let flagged = 0;
  for (const filePath of files) {
    const lines = await readLines(filePath);
    for (let index = 0; index < lines.length; index += 1) {
      const line = lines[index]!;
      const match = line.match(/setAbilityCooldown\(Button\.(ABILITY_1|ABILITY_2|SECONDARY_FIRE|ULTIMATE),/);
      if (!match) {
        continue;
      }
      checked += 1;
      if (line.includes("getAbilityCooldown(")) {
        continue;
      }
      flagged += 1;
      const button = match[1]!;
      const expectedKey =
        button === "ABILITY_1"
          ? "ability1Cooldown%"
          : button === "ABILITY_2"
            ? "ability2Cooldown%"
            : button === "SECONDARY_FIRE"
              ? "secondaryFireCooldown%"
              : "";
      const rel = path.relative(repoRoot, filePath);
      if (expectedKey) {
        if (await heroSettingsKeyPresentForBothTeams(heroKey, expectedKey)) {
          const message = `[cooldown] ${rel}:${index + 1} uses absolute setAbilityCooldown(${button}); keep generic cooldown in settings and keep only trigger-dependent cooldown logic in rules`;
          strict ? reporter.fail(message) : reporter.warn(message);
        } else {
          const message = `[cooldown] ${rel}:${index + 1} uses absolute setAbilityCooldown(${button}) but missing ${expectedKey} under team1/team2 settings for hero ${heroKey}`;
          strict ? reporter.fail(message) : reporter.warn(message);
        }
      } else {
        const message = `[cooldown] ${rel}:${index + 1} uses absolute setAbilityCooldown(${button}); verify this is trigger-dependent and not generic cooldown tuning`;
        strict ? reporter.fail(message) : reporter.warn(message);
      }
    }
  }
  if (checked === 0) {
    reporter.pass(`[cooldown] no setAbilityCooldown usage detected in hero_rules for ${slug}`);
  } else if (flagged === 0) {
    reporter.pass(`[cooldown] cooldown placement check passed for ${slug} (${checked} setAbilityCooldown calls reviewed)`);
  }
}

async function auditThrottleRisks(reporter: Reporter, slug: string, files: string[], strict: boolean): Promise<void> {
  if (files.length === 0) {
    reporter.warn(`[throttle] no hero_rules files found for ${slug}, skip throttle audit`);
    return;
  }
  let checked = 0;
  let risky = 0;
  for (const filePath of files) {
    const lines = await readLines(filePath);
    let blockRule = "";
    let blockLine = 0;
    let blockEachPlayer = false;
    let blockHasWait = false;
    let blockHasLoop = false;
    let blockHasExpensive = false;

    const evaluate = (): void => {
      if (!blockRule || !blockEachPlayer) {
        return;
      }
      checked += 1;
      const rel = path.relative(repoRoot, filePath);
      if (blockHasLoop && !blockHasWait) {
        risky += 1;
        const message = `[throttle] ${rel}:${blockLine} '${blockRule}' has loop/while without wait/waitUntil`;
        strict ? reporter.fail(message) : reporter.warn(message);
      } else if (blockHasExpensive && !blockHasWait) {
        risky += 1;
        const message = `[throttle] ${rel}:${blockLine} '${blockRule}' has expensive actions without wait/waitUntil`;
        strict ? reporter.fail(message) : reporter.warn(message);
      }
    };

    for (let index = 0; index < lines.length; index += 1) {
      const line = lines[index]!;
      const ruleMatch = line.match(/^rule "([^"]+)"/);
      if (ruleMatch) {
        evaluate();
        blockRule = ruleMatch[1]!;
        blockLine = index + 1;
        blockEachPlayer = false;
        blockHasWait = false;
        blockHasLoop = false;
        blockHasExpensive = false;
        continue;
      }
      if (line.includes("@Event eachPlayer")) {
        blockEachPlayer = true;
      }
      if (line.includes("wait(") || line.includes("waitUntil(")) {
        blockHasWait = true;
      }
      if (line.includes("loop()") || /^\s*while\s/.test(line)) {
        blockHasLoop = true;
      }
      if (
        /(getPlayersInRadius|distance|isInLoS|getClosestPlayer|getPlayerClosestToReticle|len\(\[|hudText|playEffect|startDamageModification|sort\(|nearestWalkablePosition)/.test(
          line,
        )
      ) {
        blockHasExpensive = true;
      }
    }
    evaluate();
  }
  if (checked === 0) {
    reporter.warn(`[throttle] no eachPlayer hero_rules blocks scanned for ${slug}`);
  } else if (risky === 0) {
    reporter.pass(`[throttle] no high-frequency throttle risks detected for ${slug} (${checked} eachPlayer blocks checked)`);
  }
}

async function generateReviewReportTemplate(
  targetPath: string,
  heroes: string[],
  reporter: Reporter,
): Promise<void> {
  const output = [
    "# Hero Change Review Report Template",
    "",
    `- Generated At: ${new Date().toISOString()}`,
    `- Branch: ${tryCommand("git", ["branch", "--show-current"]).trim()}`,
    `- Target Heroes: ${heroes.join(" ")}`,
    `- Automated Summary: ${reporter.passes} passed / ${reporter.warnings} warnings / ${reporter.failures} failures`,
    "",
    "## Blocking Findings (FAIL)",
    "- None",
    "",
    "## Warnings (WARN)",
    "- None",
    "",
    "## Manual Review Checklist",
  ];
  for (const hero of heroes) {
    output.push(`### ${hero}`);
    output.push("- [ ] hero_init Detect/Initialize 逻辑和 reset 链路符合预期");
    output.push("- [ ] hero_rules 行为改动符合设计并已评估负载风险");
    output.push("- [ ] changelog 文案已覆盖本次改动");
    output.push("- [ ] Team 1/Team 2 职责边界未被破坏");
    output.push("");
  }
  output.push("## Release Notes Draft");
  output.push("- 影响英雄/系统：");
  output.push("- 服务器负载影响：");
  output.push("- 初始化或 reset 链路调整：");
  await fs.mkdir(path.dirname(targetPath), { recursive: true });
  await fs.writeFile(targetPath, `${output.join("\n")}\n`, "utf8");
  reporter.pass(`review report template generated: ${path.relative(repoRoot, targetPath)}`);
}

async function auditHero(slug: string, args: Args, reporter: Reporter): Promise<void> {
  const initFile = resolveRepo("src/heroes", slug, "init.opy");
  const detectFile = resolveRepo("src/heroes", slug, "init-detect.opy");
  const heroesMain = await readLines(resolveRepo("src/heroes/main.opy"));
  const heroesAram = await readLines(resolveRepo("src/heroes/aram.opy"));
  const changelogFile = await readLines(resolveRepo("src/modules/debug/changelog.opy"));
  const currentHeroDir = resolveRepo("src/heroes", slug);

  console.log();
  console.log(`=== Hero: ${slug} ===`);

  try {
    await fs.access(initFile);
    reporter.pass(`hero_init file exists: ${path.relative(repoRoot, initFile)}`);
  } catch {
    reporter.fail(`hero_init file missing: ${path.relative(repoRoot, initFile)}`);
    return;
  }

  const rulesIncludeCount = countOccurrences(heroesMain, `#!include "${slug}/rules.opy"`);
  rulesIncludeCount === 1
    ? reporter.pass("hero rules include exists in src/heroes/main.opy")
    : reporter.fail(`hero rules include missing/duplicated in src/heroes/main.opy (count=${rulesIncludeCount})`);

  const mainInitIncludeCount = countOccurrences(heroesMain, `#!include "${slug}/init.opy"`);
  const aramInitIncludeCount = countOccurrences(heroesAram, `#!include "${slug}/init.opy"`);
  if (mainInitIncludeCount === 1 && aramInitIncludeCount === 1) {
    reporter.pass("hero init include exists in src/heroes/main.opy and src/heroes/aram.opy");
  } else {
    reporter.fail(
      `hero init include missing/duplicated in src/heroes/main.opy + src/heroes/aram.opy (main=${mainInitIncludeCount} aram=${aramInitIncludeCount})`,
    );
  }

  const sourceFiles = [initFile];
  try {
    await fs.access(detectFile);
    sourceFiles.push(detectFile);
    const initLines = await readLines(initFile);
    const detectIncludeCount = countOccurrences(initLines, '#!include "init-detect.opy"');
    detectIncludeCount === 1
      ? reporter.pass("hero init includes init-detect.opy")
      : reporter.fail(`hero init should include init-detect.opy exactly once (count=${detectIncludeCount})`);
  } catch {
    // no detect file
  }

  let ruleCount = 0;
  let trueCount = 0;
  let falseCount = 0;
  let resetHeroCount = 0;
  let condCount = 0;
  for (const filePath of sourceFiles) {
    const lines = await readLines(filePath);
    ruleCount += lines.filter((line) => line.startsWith('rule "')).length;
    trueCount += countOccurrences(lines, "eventPlayer.reset_pvar[0] = true");
    falseCount += countOccurrences(lines, "eventPlayer.reset_pvar[0] = false");
    resetHeroCount += countOccurrences(lines, "resetHero()");
    condCount += lines.filter(
      (line) =>
        line.includes("@Condition eventPlayer.reset_pvar[0] != false") ||
        line.includes("@Condition eventPlayer.reset_pvar[0] == true"),
    ).length;
  }

  ruleCount >= 2 ? reporter.pass(`detect/initialize pair likely present (rule count=${ruleCount})`) : reporter.fail(`expected at least 2 rules in hero_init file (got ${ruleCount})`);
  trueCount >= 1 ? reporter.pass("init detect trigger exists: reset_pvar[0] = true") : reporter.fail("missing detect trigger: reset_pvar[0] = true");
  resetHeroCount >= 1 ? reporter.pass("init reset chain exists: resetHero()") : reporter.fail("missing resetHero() in hero init");
  falseCount >= 1 ? reporter.pass("init clear trigger exists: reset_pvar[0] = false") : reporter.fail("missing reset clear: reset_pvar[0] = false");
  if (condCount >= 1) {
    reporter.pass("initialize gating condition exists for reset_pvar[0]");
  } else if (args.strictInitGate) {
    reporter.fail("missing initialize gating condition for reset_pvar[0]");
  } else {
    reporter.warn("missing initialize gating condition for reset_pvar[0]");
  }

  const initLines = await readLines(initFile);
  const heroTag = initLines.find((line) => line.includes("@Hero "))?.match(/@Hero\s+([^\s]+)/)?.[1] ?? slug;
  reporter.pass(`hero tag resolved from init: @Hero ${heroTag}`);
  const heroConst = normalizeConstFromTag(heroTag);

  const resetLine = firstMatchLine(initLines, "resetHero()");
  const falseLine = firstMatchLine(initLines, "eventPlayer.reset_pvar[0] = false");
  if (resetLine && falseLine) {
    falseLine > resetLine ? reporter.pass("init clear happens after resetHero()") : reporter.fail("reset_pvar[0] = false appears before resetHero()");
  }

  const knownSlots = new Set([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16]);
  for (let index = 0; index < initLines.length; index += 1) {
    const line = initLines[index]!;
    if (!line.includes("reset_pvar[")) {
      continue;
    }
    if (/reset_pvar\[[0-9]+\]\.reset_pvar\[[0-9]+\]\s*=/.test(line)) {
      const nested = line.match(/reset_pvar\[([0-9]+)\]\.reset_pvar\[([0-9]+)\]/);
      if (nested?.[1] === "6" && nested?.[2] === "9") {
        reporter.pass(`reset_pvar nested semantics OK at ${slug}.opy:${index + 1} (6 -> 9 chain)`);
      } else {
        reporter.warn(`reset_pvar nested semantics unusual at ${slug}.opy:${index + 1}`);
      }
      continue;
    }
    const slot = Number(line.match(/reset_pvar\[([0-9]+)\]/)?.[1] ?? "-1");
    if (slot < 0) {
      continue;
    }
    knownSlots.has(slot)
      ? reporter.pass(`reset_pvar write uses known slot at ${slug}.opy:${index + 1} -> [${slot}]`)
      : reporter.warn(`reset_pvar write uses unknown slot at ${slug}.opy:${index + 1} -> [${slot}]`);
    const expr = line.split("=").slice(1).join("=").trim();
    if (slot === 0) {
      expr === "true" || expr === "false"
        ? reporter.pass(`slot[0] boolean semantics OK at ${slug}.opy:${index + 1}`)
        : reporter.fail(`slot[0] expects boolean value at ${slug}.opy:${index + 1}, found: ${expr}`);
      continue;
    }
    const expectedOwner = expectedOwnerForSlot(slot);
    const expectedTeam = expectedTeamForSlot(slot);
    if (expectedOwner && heroTag !== expectedOwner) {
      reporter.warn(`slot[${slot}] semantic owner mismatch at ${slug}.opy:${index + 1}: hero @Hero ${heroTag} writes slot expected for ${expectedOwner}`);
    }
    if (expectedTeam === "ally" && line.includes("getPlayers(getOppositeTeam(eventPlayer.getTeam())).reset_pvar")) {
      reporter.warn(`slot[${slot}] expects ally mapping at ${slug}.opy:${index + 1}, but writes to opposite team`);
    }
    if (expectedTeam === "enemy" && line.includes("getPlayers(eventPlayer.getTeam()).reset_pvar")) {
      reporter.warn(`slot[${slot}] expects enemy mapping at ${slug}.opy:${index + 1}, but writes to ally team`);
    }
    if (expectedTeam === "ally" && line.includes("getPlayers(eventPlayer.getTeam()).reset_pvar")) {
      reporter.pass(`slot[${slot}] ally direction semantics OK at ${slug}.opy:${index + 1}`);
    }
    if (expectedTeam === "enemy" && line.includes("getPlayers(getOppositeTeam(eventPlayer.getTeam())).reset_pvar")) {
      reporter.pass(`slot[${slot}] enemy direction semantics OK at ${slug}.opy:${index + 1}`);
    }
  }

  const touchedRuleFiles = (await fs.readdir(currentHeroDir))
    .filter((name) => name.endsWith(".opy") && !["init.opy", "main.opy", "aram.opy"].includes(name))
    .map((name) => path.join(currentHeroDir, name))
    .filter(async () => true);
  const ruleFiles: string[] = [];
  for (const filePath of (await fs.readdir(currentHeroDir)).filter((name) => name.endsWith(".opy") && !["init.opy", "main.opy", "aram.opy"].includes(name))) {
    const fullPath = path.join(currentHeroDir, filePath);
    const text = await fs.readFile(fullPath, "utf8");
    if (text.includes(`@Hero ${heroTag}`) || text.includes(`Hero.${heroConst}`)) {
      ruleFiles.push(fullPath);
    }
  }

  if (ruleFiles.length > 0) {
    reporter.pass(`hero_rules touchpoint detected for ${slug}`);
    await auditCooldownPlacement(reporter, slug, heroTag, ruleFiles, args.strictCooldownPlacement);
    await auditThrottleRisks(reporter, slug, ruleFiles, args.strictThrottle);
  } else if (args.strictRules) {
    reporter.fail(`no hero_rules touchpoint detected for ${slug}`);
  } else {
    reporter.warn(`no hero_rules touchpoint detected for ${slug}`);
  }

  const changelogCount = changelogFile.filter((line) => line.includes(`eventPlayer.getHero() == Hero.${heroConst}`)).length;
  if (changelogCount >= 1) {
    reporter.pass(`changelog branch exists for Hero.${heroConst}`);
  } else if (args.strictChangelog) {
    reporter.fail(`missing changelog branch for Hero.${heroConst}`);
  } else {
    reporter.warn(`missing changelog branch for Hero.${heroConst}`);
  }
}

async function main(): Promise<void> {
  const args = parseArgs(process.argv.slice(2));
  const reporter = new Reporter();
  if (args.listHeroes) {
    console.log("Available heroes (from src/heroes/*/init.opy):");
    console.log(listAllHeroesSync().join("\n"));
    return;
  }

  const requestHeroes = [...args.requestHeroes];
  if (args.useFromDiff) {
    requestHeroes.push(...collectHeroesFromDiff(args.diffRange));
  }
  const heroes = [...new Set(requestHeroes.filter(Boolean))].sort((a, b) => a.localeCompare(b));
  if (heroes.length === 0) {
    if (args.useFromDiff) {
      console.log(`No hero-related file changes detected from diff range: ${args.diffRange}`);
      return;
    }
    throw new Error("No target heroes provided. Use --hero <slug> or --from-diff [range].");
  }

  console.log(`Running ow-hero-change-pipeline from: ${repoRoot}`);
  console.log(`Target heroes: ${heroes.join(" ")}`);
  for (const hero of heroes) {
    await auditHero(hero, args, reporter);
  }

  if (args.runBuild) {
    console.log();
    console.log("Running contract guard + build gate...");
    const result = spawnSync(process.execPath, ["--import", "tsx", resolveRepo("tools/check-contracts.ts"), "--build"], {
      cwd: repoRoot,
      stdio: "inherit",
    });
    result.status === 0 ? reporter.pass("contract guard and build succeeded") : reporter.fail("contract guard or build failed");
  }

  if (args.reportTemplate) {
    const reportPath =
      args.reportPath !== null
        ? resolveRepo(args.reportPath)
        : resolveRepo(`docs/reports/hero-pipeline-review-${new Date().toISOString().replace(/[:.]/g, "-")}.md`);
    await generateReviewReportTemplate(reportPath, heroes, reporter);
  }

  reporter.summary();
  process.exit(reporter.exitCode());
}

main().catch((error: Error) => {
  console.error(error.message);
  process.exit(1);
});
