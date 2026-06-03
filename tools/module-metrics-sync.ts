#!/usr/bin/env -S node --import tsx

import fs from "node:fs/promises";
import path from "node:path";
import { Reporter } from "./lib/report.js";
import { repoRoot, resolveRepo, tryCommand } from "./lib/runtime.js";

type Args = {
  checkOnly: boolean;
  emitReport: boolean;
  reportPath: string | null;
};

function parseArgs(argv: string[]): Args {
  const args: Args = { checkOnly: false, emitReport: false, reportPath: null };
  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index]!;
    switch (arg) {
      case "--check":
        args.checkOnly = true;
        break;
      case "--report":
        args.emitReport = true;
        if (argv[index + 1] && !argv[index + 1]!.startsWith("--")) {
          args.reportPath = argv[++index]!;
        }
        break;
      case "-h":
      case "--help":
        console.log("Usage: tools/module-metrics-sync.ts [--check] [--report [path]]");
        process.exit(0);
      default:
        throw new Error(`Unknown argument: ${arg}`);
    }
  }
  return args;
}

async function listOpyFiles(current: string): Promise<string[]> {
  const entries = await fs.readdir(current, { withFileTypes: true });
  const files: string[] = [];
  for (const entry of entries) {
    const next = path.join(current, entry.name);
    if (entry.isDirectory()) {
      files.push(...(await listOpyFiles(next)));
    } else if (entry.name.endsWith(".opy")) {
      files.push(next);
    }
  }
  return files;
}

async function countPattern(targetPath: string, pattern: RegExp): Promise<number> {
  const stat = await fs.stat(targetPath);
  if (stat.isFile()) {
    return (await fs.readFile(targetPath, "utf8"))
      .split(/\r?\n/)
      .filter((line) => pattern.test(line)).length;
  }
  const files = await listOpyFiles(targetPath);
  let count = 0;
  for (const filePath of files) {
    count += (await fs.readFile(filePath, "utf8"))
      .split(/\r?\n/)
      .filter((line) => pattern.test(line)).length;
  }
  return count;
}

function replaceExactlyOne(content: string, regex: RegExp, replacement: string, label: string): string {
  const matches = [...content.matchAll(new RegExp(regex.source, regex.flags.includes("g") ? regex.flags : `${regex.flags}g`))];
  if (matches.length === 0) {
    throw new Error(`pattern not found in ${label}: ${regex.source}`);
  }
  if (matches.length > 1) {
    throw new Error(`pattern matched multiple lines in ${label}: ${regex.source}`);
  }
  return content.replace(regex, replacement);
}

function replaceIfPresent(content: string, regex: RegExp, replacement: string): { content: string; replaced: boolean } {
  const flags = regex.flags.includes("g") ? regex.flags : `${regex.flags}g`;
  const matches = [...content.matchAll(new RegExp(regex.source, flags))];
  if (matches.length === 0) {
    return { content, replaced: false };
  }
  if (matches.length > 1) {
    throw new Error(`pattern matched multiple lines: ${regex.source}`);
  }
  return { content: content.replace(regex, replacement), replaced: true };
}

async function main(): Promise<void> {
  const args = parseArgs(process.argv.slice(2));
  const reporter = new Reporter();
  const docsTargets = [
    "docs/modules/01-main-opy-architecture.md",
    "docs/modules/02-modular-split-plan.md",
    "docs/modules/04-current-implementation-summary.md",
    "docs/modules/appendix-src-file-index.md",
  ];

  console.log(`Running ow-module-metrics-sync from: ${repoRoot}`);
  for (const target of docsTargets) {
    try {
      await fs.access(resolveRepo(target));
      reporter.pass(`managed doc found: ${target}`);
    } catch {
      reporter.fail(`managed doc missing: ${target}`);
    }
  }

  const metrics = {
    totalRules: await countPattern(resolveRepo("src/modules"), /^rule "/),
    globalvarTotal: await countPattern(resolveRepo("src/modules/prelude/global-vars.opy"), /^globalvar\s/),
    playervarTotal: await countPattern(resolveRepo("src/modules/prelude/player-vars.opy"), /^playervar\s/),
    subroutineTotal: await countPattern(resolveRepo("src/modules/prelude/subroutine.opy"), /^subroutine\s/),
    defTotal: await countPattern(resolveRepo("src/modules"), /^def\s+[A-Za-z0-9_]+\(/),
    disabledTotal: await countPattern(resolveRepo("src/modules"), /@Disabled\b/),
    bootstrapRules: await countPattern(resolveRepo("src/modules/bootstrap"), /^rule "/),
    bootstrapDefs: await countPattern(resolveRepo("src/modules/bootstrap"), /^def\s+[A-Za-z0-9_]+\(/),
    aiRules: await countPattern(resolveRepo("src/modules/ai"), /^rule "/),
    aiDefs: await countPattern(resolveRepo("src/modules/ai"), /^def\s+[A-Za-z0-9_]+\(/),
    heroRulesRules: await countPattern(resolveRepo("src/modules/hero_rules"), /^rule "/),
    heroRulesDefs: await countPattern(resolveRepo("src/modules/hero_rules"), /^def\s+[A-Za-z0-9_]+\(/),
    heroInitRules: await countPattern(resolveRepo("src/modules/hero_init"), /^rule "/),
    heroInitDefs: await countPattern(resolveRepo("src/modules/hero_init"), /^def\s+[A-Za-z0-9_]+\(/),
    debugRules: await countPattern(resolveRepo("src/modules/debug"), /^rule "/),
    debugDefs: await countPattern(resolveRepo("src/modules/debug"), /^def\s+[A-Za-z0-9_]+\(/),
    legacyRulesTotal: await countPattern(resolveRepo("src"), /^rule "/),
    legacyDefsTotal: await countPattern(resolveRepo("src"), /^def\s+[A-Za-z0-9_]+\(/),
    legacyDisabledTotal: await countPattern(resolveRepo("src"), /@Disabled\b/),
  };

  const rulesOutsideModules = metrics.legacyRulesTotal - metrics.totalRules;
  const defsOutsideModules = metrics.legacyDefsTotal - metrics.defTotal;
  const disabledOutsideModules = metrics.legacyDisabledTotal - metrics.disabledTotal;
  const moduleRuleSum =
    metrics.bootstrapRules + metrics.aiRules + metrics.heroRulesRules + metrics.heroInitRules + metrics.debugRules;
  const moduleDefSum =
    metrics.bootstrapDefs + metrics.aiDefs + metrics.heroRulesDefs + metrics.heroInitDefs + metrics.debugDefs;

  moduleRuleSum === metrics.totalRules
    ? reporter.pass(`module rule sum matches total rule count (${moduleRuleSum})`)
    : reporter.warn(`module rule sum (${moduleRuleSum}) differs from total rules (${metrics.totalRules})`);
  moduleDefSum === metrics.defTotal
    ? reporter.pass(`module def sum matches total def count (${moduleDefSum})`)
    : reporter.warn(`module def sum (${moduleDefSum}) differs from total defs (${metrics.defTotal})`);
  rulesOutsideModules > 0 || defsOutsideModules > 0 || disabledOutsideModules > 0
    ? reporter.warn(`ignored non-module declarations under src (rules=${rulesOutsideModules}, defs=${defsOutsideModules}, disabled=${disabledOutsideModules})`)
    : reporter.pass("no extra declarations outside src/modules");

  console.log(
    `Computed metrics: rule=${metrics.totalRules}, globalvar=${metrics.globalvarTotal}, playervar=${metrics.playervarTotal}, subroutine=${metrics.subroutineTotal}, def=${metrics.defTotal}, disabled=${metrics.disabledTotal}`,
  );

  const updatedContents = new Map<string, string>();
  for (const target of docsTargets) {
    const fullPath = resolveRepo(target);
    let content = await fs.readFile(fullPath, "utf8");
    content = content.replaceAll("subroutine-names.opy", "subroutine.opy");

    if (target.endsWith("01-main-opy-architecture.md")) {
      content = replaceIfPresent(content, /^- 规则数：`[0-9]+`$/m, `- 规则数：\`${metrics.totalRules}\``).content;
      content = replaceIfPresent(content, /^- `globalvar`：`[0-9]+`$/m, `- \`globalvar\`：\`${metrics.globalvarTotal}\``).content;
      content = replaceIfPresent(content, /^- `playervar`：`[0-9]+`$/m, `- \`playervar\`：\`${metrics.playervarTotal}\``).content;
      content = replaceIfPresent(content, /^- `subroutine` 声明：`[0-9]+`$/m, `- \`subroutine\` 声明：\`${metrics.subroutineTotal}\``).content;
      content = replaceIfPresent(content, /^- `def` 子程序实现：`[0-9]+`$/m, `- \`def\` 子程序实现：\`${metrics.defTotal}\``).content;
      content = replaceIfPresent(content, /^- `@Disabled` 规则：`[0-9]+`$/m, `- \`@Disabled\` 规则：\`${metrics.disabledTotal}\``).content;
    }
    if (target.endsWith("04-current-implementation-summary.md")) {
      content = replaceIfPresent(content, /^- `rule` 总数：`[0-9]+`$/m, `- \`rule\` 总数：\`${metrics.totalRules}\``).content;
      content = replaceIfPresent(content, /^- `globalvar`：`[0-9]+`$/m, `- \`globalvar\`：\`${metrics.globalvarTotal}\``).content;
      content = replaceIfPresent(content, /^- `playervar`：`[0-9]+`$/m, `- \`playervar\`：\`${metrics.playervarTotal}\``).content;
      content = replaceIfPresent(content, /^- `subroutine` 声明：`[0-9]+`$/m, `- \`subroutine\` 声明：\`${metrics.subroutineTotal}\``).content;
      content = replaceIfPresent(content, /^- `def` 子程序实现：`[0-9]+`$/m, `- \`def\` 子程序实现：\`${metrics.defTotal}\``).content;
      content = replaceIfPresent(content, /^- `@Disabled`：`[0-9]+`$/m, `- \`@Disabled\`：\`${metrics.disabledTotal}\``).content;
      content = replaceIfPresent(content, /^- `bootstrap`：`[0-9]+` 条规则 \+ `[0-9]+` 个 `def`$/m, `- \`bootstrap\`：\`${metrics.bootstrapRules}\` 条规则 + \`${metrics.bootstrapDefs}\` 个 \`def\``).content;
      content = replaceIfPresent(content, /^- `ai`：`[0-9]+` 条规则 \+ `[0-9]+` 个 `def`.*$/m, `- \`ai\`：\`${metrics.aiRules}\` 条规则 + \`${metrics.aiDefs}\` 个 \`def\`（\`botAim2Target()\`）`).content;
      content = replaceIfPresent(content, /^- `hero_rules`：`[0-9]+` 条规则 \+ `[0-9]+` 个 `def`.*$/m, `- \`hero_rules\`：\`${metrics.heroRulesRules}\` 条规则 + \`${metrics.heroRulesDefs}\` 个 \`def\`（\`Knockback()\`）`).content;
      content = replaceIfPresent(content, /^- `hero_init`：`[0-9]+` 条规则（.*$/m, `- \`hero_init\`：\`${metrics.heroInitRules}\` 条规则（\`heroes/* + extras/* + delimiters\`）`).content;
      content = replaceIfPresent(content, /^- `debug`：`[0-9]+` 条规则 \+ `[0-9]+` 个 `def`.*$/m, `- \`debug\`：\`${metrics.debugRules}\` 条规则 + \`${metrics.debugDefs}\` 个 \`def\`（\`changelogText()\`）`).content;
    }
    if (target.endsWith("appendix-src-file-index.md")) {
      content = replaceIfPresent(content, /^- `rule` 总数应保持 `[0-9]+`$/m, `- \`rule\` 总数应保持 \`${metrics.totalRules}\``).content;
    }
    if (target.endsWith("02-modular-split-plan.md")) {
      content = replaceExactlyOne(content, /^- 规则总数维持 `[0-9]+`$/m, `- 规则总数维持 \`${metrics.totalRules}\``, target);
    }
    updatedContents.set(fullPath, content);
  }

  const changedFiles: string[] = [];
  for (const [fullPath, content] of updatedContents.entries()) {
    const current = await fs.readFile(fullPath, "utf8");
    if (current !== content) {
      changedFiles.push(path.relative(repoRoot, fullPath));
      if (args.checkOnly) {
        reporter.fail(`metrics drift detected: ${path.relative(repoRoot, fullPath)}`);
      } else {
        await fs.writeFile(fullPath, content, "utf8");
        reporter.pass(`metrics updated: ${path.relative(repoRoot, fullPath)}`);
      }
    } else {
      reporter.pass(`metrics already in sync: ${path.relative(repoRoot, fullPath)}`);
    }
  }

  if (args.emitReport) {
    const reportPath =
      args.reportPath !== null
        ? resolveRepo(args.reportPath)
        : resolveRepo(`docs/reports/module-metrics-sync-${new Date().toISOString().replace(/[:.]/g, "-")}.md`);
    const reportLines = [
      "# Module Metrics Sync Report",
      "",
      `- Generated At: ${new Date().toISOString()}`,
      `- Branch: ${tryCommand("git", ["branch", "--show-current"]).trim()}`,
      `- Mode: ${args.checkOnly ? "check" : "write"}`,
      "",
      "## Global Metrics",
      `- rule: ${metrics.totalRules}`,
      `- globalvar: ${metrics.globalvarTotal}`,
      `- playervar: ${metrics.playervarTotal}`,
      `- subroutine: ${metrics.subroutineTotal}`,
      `- def: ${metrics.defTotal}`,
      `- @Disabled: ${metrics.disabledTotal}`,
      "",
      "## Module Metrics",
      `- bootstrap: ${metrics.bootstrapRules} rules / ${metrics.bootstrapDefs} defs`,
      `- ai: ${metrics.aiRules} rules / ${metrics.aiDefs} defs`,
      `- hero_rules: ${metrics.heroRulesRules} rules / ${metrics.heroRulesDefs} defs`,
      `- hero_init: ${metrics.heroInitRules} rules / ${metrics.heroInitDefs} defs`,
      `- debug: ${metrics.debugRules} rules / ${metrics.debugDefs} defs`,
      "",
      "## Managed Docs",
      ...(changedFiles.length > 0 ? changedFiles.map((file) => `- ${file}`) : ["- No diffs"]),
      "",
      "## Summary",
      `- ${reporter.passes} passed / ${reporter.warnings} warnings / ${reporter.failures} failures`,
    ];
    await fs.mkdir(path.dirname(reportPath), { recursive: true });
    await fs.writeFile(reportPath, `${reportLines.join("\n")}\n`, "utf8");
    reporter.pass(`report generated: ${path.relative(repoRoot, reportPath)}`);
  }

  reporter.summary();
  process.exit(reporter.exitCode());
}

main().catch((error: Error) => {
  console.error(error.message);
  process.exit(1);
});
