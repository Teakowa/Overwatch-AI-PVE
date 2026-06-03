#!/usr/bin/env -S node --import tsx

import fs from "node:fs/promises";
import path from "node:path";
import { Reporter } from "./lib/report.js";
import { existsSync, gitDiffNameOnly, readLines, repoRoot, resolveRepo, tryCommand } from "./lib/runtime.js";

type Args = {
  requestedHeroes: string[];
  useFromDiff: boolean;
  diffRange: string;
  strictCoverage: boolean;
  strictLanguage: boolean;
  strictSettingsSync: boolean;
  emitReport: boolean;
  reportPath: string | null;
  listHeroes: boolean;
};

function parseArgs(argv: string[]): Args {
  const args: Args = {
    requestedHeroes: [],
    useFromDiff: false,
    diffRange: "HEAD",
    strictCoverage: false,
    strictLanguage: true,
    strictSettingsSync: false,
    emitReport: false,
    reportPath: null,
    listHeroes: false,
  };
  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index]!;
    switch (arg) {
      case "--hero":
        args.requestedHeroes.push(argv[++index] ?? "");
        break;
      case "--from-diff":
        args.useFromDiff = true;
        if (argv[index + 1] && !argv[index + 1]!.startsWith("--")) {
          args.diffRange = argv[++index]!;
        }
        break;
      case "--strict-coverage":
        args.strictCoverage = true;
        break;
      case "--strict-language":
        args.strictLanguage = true;
        break;
      case "--strict-settings-sync":
        args.strictSettingsSync = true;
        break;
      case "--report":
        args.emitReport = true;
        if (argv[index + 1] && !argv[index + 1]!.startsWith("--")) {
          args.reportPath = argv[++index]!;
        }
        break;
      case "--list-heroes":
        args.listHeroes = true;
        break;
      case "-h":
      case "--help":
        console.log("Usage: tools/changelog-sync.ts [--hero <slug>]... [--from-diff [range]] [--report [path]]");
        process.exit(0);
      default:
        throw new Error(`Unknown argument: ${arg}`);
    }
  }
  return args;
}

function listHeroes(): string[] {
  return tryCommand("find", [resolveRepo("src/heroes"), "-name", "init.opy"], repoRoot)
    .split("\n")
    .filter(Boolean)
    .map((line) => line.match(/src\/heroes\/([^/]+)\/init\.opy$/)?.[1] ?? "")
    .filter(Boolean)
    .sort((a, b) => a.localeCompare(b));
}

function normalizeTagToSlug(tag: string): string {
  const normalized = tag.replace(/([a-z0-9])([A-Z])/g, "$1_$2").toLowerCase();
  if (normalized === "soldier") return "soldier76";
  if (normalized === "wreckingball") return "wrecking_ball";
  if (normalized === "junkerqueen") return "junker_queen";
  return normalized;
}

function slugFromConst(value: string): string {
  if (value === "SOLDIER") return "soldier76";
  if (value === "WRECKING_BALL") return "wrecking_ball";
  if (value === "JUNKER_QUEEN") return "junker_queen";
  return value.toLowerCase();
}

function slugToSettingsKey(value: string): string {
  if (value === "wrecking_ball") return "wreckingBall";
  if (value === "junker_queen") return "junkerQueen";
  if (!value.includes("_")) return value;
  const [head, ...rest] = value.split("_");
  return `${head}${rest.map((part) => `${part[0]!.toUpperCase()}${part.slice(1)}`).join("")}`;
}

function constFromSlug(value: string): string {
  if (value === "soldier76") return "SOLDIER";
  if (value === "wrecking_ball") return "WRECKING_BALL";
  if (value === "junker_queen") return "JUNKER_QUEEN";
  return value.toUpperCase();
}

function addTargetHero(targets: Set<string>, raw: string): void {
  const slug = normalizeTagToSlug(raw);
  if (slug && existsSync(resolveRepo("src/heroes", slug, "init.opy"))) {
    targets.add(slug);
  }
}

function containsBannedTeamWording(text: string): string[] {
  const patterns = ["Team 1", "Team1", "Team 2", "Team2", "队伍1", "队伍 1", "队伍2", "队伍 2", "机器人队伍", "玩家队伍", "阵营"];
  return patterns.filter((pattern) => text.includes(pattern));
}

function sanitizeDiffLine(line: string): string {
  return line
    .replaceAll("Team.1", "特定队伍")
    .replaceAll("Team.2", "特定队伍")
    .replaceAll("getOppositeTeam(eventPlayer.getTeam())", "敌方目标")
    .replaceAll("eventPlayer.getTeam()", "当前队伍")
    .replace(/\s+/g, " ")
    .trim()
    .slice(0, 120);
}

async function collectSettingsCooldownCluesForHero(slug: string, range: string): Promise<string[]> {
  const settingsFile = resolveRepo("src/modules/prelude/settings.opy");
  const heroKey = slugToSettingsKey(slug);
  const diff = tryCommand("git", ["diff", "--unified=3", range, "--", settingsFile], repoRoot);
  const lines = diff.split("\n");
  const clues = new Set<string>();
  let current = "";
  for (const line of lines) {
    const sectionMatch = line.match(/^[ +-]\s*"([^"]+)"\s*:\s*{\s*$/);
    if (sectionMatch) {
      current = sectionMatch[1]!;
      continue;
    }
    if (current !== heroKey) {
      continue;
    }
    const clueMatch = line.match(/^([+-])\s*"(ability1Cooldown%|ability2Cooldown%|secondaryFireCooldown%)"\s*:\s*(.+)$/);
    if (clueMatch) {
      const prefix = clueMatch[1] === "+" ? "新增线索" : "移除线索";
      clues.add(`${prefix}: settings "${clueMatch[2]}" : ${clueMatch[3].replace(/,$/, "").trim()}`);
    }
  }
  return [...clues];
}

async function collectDiffCluesForHero(slug: string, range: string): Promise<string[]> {
  const constName = constFromSlug(slug);
  const changedFiles = gitDiffNameOnly(range, ["src/heroes", "src/modules/prelude/settings.opy", "src/modules/debug/changelog.opy"]);
  const clues = new Set<string>();
  for (const filePath of changedFiles) {
    if (filePath === "src/modules/prelude/settings.opy") {
      continue;
    }
    const diff = tryCommand("git", ["diff", "--unified=0", range, "--", filePath], repoRoot);
    for (const line of diff.split("\n")) {
      if (!(line.startsWith("+") || line.startsWith("-")) || line.startsWith("+++") || line.startsWith("---")) {
        continue;
      }
      const content = line.slice(1).trim();
      if (!content || content.startsWith("#") || content.startsWith("rule ") || content.startsWith("@")) {
        continue;
      }
      let match = filePath.startsWith(`src/heroes/${slug}/`) || content.includes(`Hero.${constName}`);
      const tagMatch = content.match(/@Hero\s+([A-Za-z0-9_]+)/);
      if (tagMatch && normalizeTagToSlug(tagMatch[1]!) === slug) {
        match = true;
      }
      if (!match) {
        continue;
      }
      clues.add(`${line[0] === "+" ? "新增线索" : "移除线索"}: ${sanitizeDiffLine(content)}`);
    }
  }
  for (const clue of await collectSettingsCooldownCluesForHero(slug, range)) {
    clues.add(clue);
  }
  return [...clues].slice(0, 10);
}

async function renderReport(reportPath: string, reporter: Reporter, heroes: string[], diffRange: string): Promise<void> {
  const lines: string[] = [
    "# Changelog Sync Report",
    "",
    `- Generated At: ${new Date().toISOString()}`,
    `- Branch: ${tryCommand("git", ["branch", "--show-current"]).trim()}`,
    `- Diff Range: ${diffRange}`,
    `- Heroes: ${heroes.join(" ")}`,
    `- Summary: ${reporter.passes} passed / ${reporter.warnings} warnings / ${reporter.failures} failures`,
    "",
    "## Coverage",
  ];
  const changelogLines = await readLines(resolveRepo("src/modules/debug/changelog.opy"));
  for (const hero of heroes) {
    const constName = constFromSlug(hero);
    const count = changelogLines.filter((line) => line.includes(`eventPlayer.getHero() == Hero.${constName}`)).length;
    if (count === 1) lines.push(`- [OK] ${hero}: Hero.${constName} branch exists`);
    else if (count > 1) lines.push(`- [WARN] ${hero}: Hero.${constName} branch duplicated (${count})`);
    else lines.push(`- [WARN] ${hero}: Hero.${constName} branch missing`);
  }
  lines.push("", "## Pending Player-Facing Changelog Items");
  for (const hero of heroes) {
    lines.push(`### ${hero}`);
    const clues = await collectDiffCluesForHero(hero, diffRange);
    if (clues.length === 0) {
      lines.push("- [ ] 未从 diff 中提取到直接线索，手动补充该英雄本次改动要点");
    } else {
      for (const clue of clues) {
        lines.push(`- [ ] ${clue}`);
      }
    }
    lines.push("- [ ] 将以上线索转译为玩家可读文案（避免队伍编号表达）", "");
  }
  lines.push("## Language Rule", "- changelog 面向玩家，不使用队伍编号表达。");
  await fs.mkdir(path.dirname(reportPath), { recursive: true });
  await fs.writeFile(reportPath, `${lines.join("\n")}\n`, "utf8");
}

async function main(): Promise<void> {
  const args = parseArgs(process.argv.slice(2));
  if (args.listHeroes) {
    console.log("Available heroes (from src/heroes/*/init.opy):");
    console.log(listHeroes().join("\n"));
    return;
  }

  const targetHeroes = new Set<string>();
  for (const hero of args.requestedHeroes) {
    addTargetHero(targetHeroes, hero);
  }
  if (args.useFromDiff) {
    const changedFiles = gitDiffNameOnly(args.diffRange, ["src/heroes", "src/modules/prelude/settings.opy", "src/modules/debug/changelog.opy"]);
    for (const filePath of changedFiles) {
      const heroMatch = filePath.match(/^src\/heroes\/([^/]+)\/.+\.opy$/);
      if (heroMatch) {
        addTargetHero(targetHeroes, heroMatch[1]!);
      }
      if (filePath === "src/modules/prelude/settings.opy") {
        const diff = tryCommand("git", ["diff", "--unified=3", args.diffRange, "--", filePath], repoRoot);
        for (const line of diff.split("\n")) {
          const match = line.match(/^[-+]\s*"([A-Za-z0-9_]+)"\s*:\s*{/);
          if (match) {
            addTargetHero(targetHeroes, match[1]!);
          }
        }
      }
    }
  }

  const heroes = [...targetHeroes].sort((a, b) => a.localeCompare(b));
  if (heroes.length === 0) {
    if (args.useFromDiff) {
      console.log(`No impacted heroes found from diff range: ${args.diffRange}`);
      return;
    }
    throw new Error("No target heroes provided. Use --hero <slug> or --from-diff [range].");
  }

  const reporter = new Reporter();
  const changelogPath = resolveRepo("src/modules/debug/changelog.opy");
  const changelogText = await fs.readFile(changelogPath, "utf8");
  console.log(`Running ow-changelog-sync from: ${repoRoot}`);
  console.log(`Target heroes: ${heroes.join(" ")}`);

  const banned = containsBannedTeamWording(changelogText);
  if (banned.length > 0) {
    for (const term of banned) {
      args.strictLanguage ? reporter.fail(`changelog content contains team-number wording: '${term}'`) : reporter.warn(`changelog content contains team-number wording: '${term}'`);
    }
  } else {
    reporter.pass("changelog content does not use Team 1/Team 2 wording");
  }

  const changelogLines = changelogText.split(/\r?\n/);
  for (const hero of heroes) {
    const constName = constFromSlug(hero);
    const coverageCount = changelogLines.filter((line) => line.includes(`eventPlayer.getHero() == Hero.${constName}`)).length;
    if (coverageCount === 1) reporter.pass(`coverage OK for ${hero} (Hero.${constName})`);
    else if (coverageCount > 1) args.strictCoverage ? reporter.fail(`coverage duplicated for ${hero} (Hero.${constName}, count=${coverageCount})`) : reporter.warn(`coverage duplicated for ${hero} (Hero.${constName}, count=${coverageCount})`);
    else args.strictCoverage ? reporter.fail(`coverage missing for ${hero} (Hero.${constName})`) : reporter.warn(`coverage missing for ${hero} (Hero.${constName})`);

    const clues = await collectDiffCluesForHero(hero, args.diffRange);
    if (clues.length > 0) {
      reporter.pass(`diff clues extracted for ${hero}`);
      for (const clue of clues) {
        console.log(`  - ${hero}: ${clue}`);
      }
    } else {
      reporter.warn(`no diff clues extracted for ${hero} from range ${args.diffRange}`);
    }

    const cooldownClues = await collectSettingsCooldownCluesForHero(hero, args.diffRange);
    if (cooldownClues.length > 0) {
      const changelogDiff = tryCommand("git", ["diff", "--unified=3", args.diffRange, "--", changelogPath], repoRoot);
      if (!changelogText.includes(`eventPlayer.getHero() == Hero.${constName}`)) {
        args.strictSettingsSync
          ? reporter.fail(`settings cooldown changed for ${hero}, but changelog branch Hero.${constName} not found`)
          : reporter.warn(`settings cooldown changed for ${hero}, but changelog branch Hero.${constName} not found`);
      } else if (changelogDiff.includes(`Hero.${constName}`)) {
        reporter.pass(`settings cooldown sync OK for ${hero} (changelog branch updated in diff)`);
      } else {
        args.strictSettingsSync
          ? reporter.fail(`settings cooldown changed for ${hero}, but changelog branch was not updated in diff`)
          : reporter.warn(`settings cooldown changed for ${hero}, but changelog branch was not updated in diff`);
      }
    }
  }

  if (args.emitReport) {
    const reportPath =
      args.reportPath !== null
        ? resolveRepo(args.reportPath)
        : resolveRepo(`docs/reports/changelog-sync-${new Date().toISOString().replace(/[:.]/g, "-")}.md`);
    await renderReport(reportPath, reporter, heroes, args.diffRange);
    const reportText = await fs.readFile(reportPath, "utf8");
    const reportBanned = containsBannedTeamWording(reportText);
    if (reportBanned.length === 0) {
      reporter.pass(`report generated: ${path.relative(repoRoot, reportPath)}`);
    } else {
      for (const term of reportBanned) {
        args.strictLanguage ? reporter.fail(`generated report contains team-number wording: '${term}'`) : reporter.warn(`generated report contains team-number wording: '${term}'`);
      }
    }
  }

  reporter.summary();
  process.exit(reporter.exitCode());
}

main().catch((error: Error) => {
  console.error(error.message);
  process.exit(1);
});
