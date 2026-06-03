#!/usr/bin/env -S node --import tsx

import fs from "node:fs/promises";
import path from "node:path";
import { repoRoot, resolveRepo } from "./lib/runtime.js";

type Args = {
  segmentMin: number;
  reportPath: string;
  whitelistPath: string;
  emitCandidatesPath: string | null;
  check: boolean;
};

type Rule = {
  name: string;
  line: number;
  end: number;
  norm: string;
  path: string;
  sourceModule?: string;
};

const RULE_RE = /^rule\s+"([^"]+)":\s*$/m;
const LEGACY_REF_RE = /aram_cross_hero_overrides|aram_overrides_segments/;
const VALID_DECISIONS = new Set(["keep_aram_only", "parameterize_shared"]);

function usage(): void {
  console.log("Usage: tools/check-aram-overrides-duplicates.ts [--segment-min N] [--report PATH] [--whitelist PATH] [--emit-candidates PATH] [--check]");
}

function parseArgs(argv: string[]): Args {
  const args: Args = {
    segmentMin: 2,
    reportPath: "build/reports/aram_overrides_duplicates.md",
    whitelistPath: "tools/data/contract-guard/aram-delta-whitelist.tsv",
    emitCandidatesPath: null,
    check: false,
  };
  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index]!;
    switch (arg) {
      case "--segment-min":
        args.segmentMin = Number(argv[++index] ?? "2");
        break;
      case "--report":
        args.reportPath = argv[++index] ?? "";
        break;
      case "--whitelist":
        args.whitelistPath = argv[++index] ?? "";
        break;
      case "--emit-candidates":
        args.emitCandidatesPath = argv[++index] ?? "";
        break;
      case "--check":
        args.check = true;
        break;
      case "-h":
      case "--help":
        usage();
        process.exit(0);
      default:
        throw new Error(`Unknown argument: ${arg}`);
    }
  }
  if (!Number.isInteger(args.segmentMin) || args.segmentMin < 0) {
    throw new Error("--segment-min must be a non-negative integer");
  }
  return args;
}

async function parseRules(filePath: string): Promise<Rule[]> {
  const text = await fs.readFile(filePath, "utf8");
  const lines = text.split(/\r?\n/);
  const rules: Rule[] = [];
  for (let index = 0; index < lines.length; ) {
    const match = lines[index]!.match(/^rule\s+"([^"]+)":\s*$/);
    if (!match) {
      index += 1;
      continue;
    }
    const start = index;
    const name = match[1]!;
    index += 1;
    while (index < lines.length && !lines[index]!.match(/^rule\s+"([^"]+)":\s*$/)) {
      index += 1;
    }
    const blockLines = lines.slice(start, index);
    const norm = `${blockLines.map((line) => line.trimEnd()).join("\n").trim()}\n`;
    rules.push({ name, line: start + 1, end: index, norm, path: filePath });
  }
  return rules;
}

function isModeOverlay(relPath: string): boolean {
  if (relPath === "src/aram_overrides.opy") {
    return false;
  }
  const base = path.basename(relPath);
  if (["aramMain.opy", "aram_settings.opy", "aram_protocol.opy"].includes(base)) {
    return false;
  }
  return base.startsWith("aram") && base.endsWith(".opy");
}

async function listFiles(current: string): Promise<string[]> {
  const entries = await fs.readdir(current, { withFileTypes: true });
  const files: string[] = [];
  for (const entry of entries) {
    const next = path.join(current, entry.name);
    if (entry.isDirectory()) {
      files.push(...(await listFiles(next)));
    } else {
      files.push(next);
    }
  }
  return files;
}

function classifyRules(rules: Rule[], otherByName: Map<string, Array<{ norm: string; path: string }>>): {
  exact: Rule[];
  diff: Rule[];
  unique: Rule[];
} {
  const exact: Rule[] = [];
  const diff: Rule[] = [];
  const unique: Rule[] = [];
  for (const rule of rules) {
    const candidates = otherByName.get(rule.name) ?? [];
    if (candidates.length === 0) {
      unique.push(rule);
    } else if (candidates.some((candidate) => candidate.norm === rule.norm)) {
      exact.push(rule);
    } else {
      diff.push(rule);
    }
  }
  return { exact, diff, unique };
}

function pickSourceModule(rule: Rule, otherByName: Map<string, Array<{ norm: string; path: string }>>, exactOnly: boolean): string {
  const candidates = (otherByName.get(rule.name) ?? []).filter((candidate) => !exactOnly || candidate.norm === rule.norm);
  if (candidates.length === 0 && exactOnly) {
    return "";
  }
  const pool = candidates.length > 0 ? candidates : otherByName.get(rule.name) ?? [];
  return pool
    .map((candidate) => path.relative(repoRoot, candidate.path))
    .sort((a, b) => a.localeCompare(b))[0] ?? "";
}

function whitelistKey(kind: string, ruleName: string, sourceModule: string): string {
  return `${kind}\t${ruleName}\t${sourceModule.trim()}`;
}

async function loadWhitelist(filePath: string): Promise<Array<Record<string, string>>> {
  const lines = (await fs.readFile(filePath, "utf8")).split(/\r?\n/).filter(Boolean);
  const headers = lines[0]!.split("\t");
  return lines.slice(1).map((line) => {
    const values = line.split("\t");
    return Object.fromEntries(headers.map((header, index) => [header, values[index] ?? ""]));
  });
}

async function main(): Promise<void> {
  const args = parseArgs(process.argv.slice(2));
  const failures: string[] = [];
  const srcRoot = resolveRepo("src");
  const aramFile = resolveRepo("src/aram_overrides.opy");
  const whitelistFile = resolveRepo(args.whitelistPath);
  const reportFile = resolveRepo(args.reportPath);
  const emitCandidatesFile = args.emitCandidatesPath ? resolveRepo(args.emitCandidatesPath) : null;

  const allFiles = await listFiles(srcRoot);
  const heroDirs = await fs.readdir(resolveRepo("src/heroes"), { withFileTypes: true });
  if (heroDirs.filter((entry) => entry.isDirectory()).length === 0) {
    failures.push("overlay scan: no hero directories found under src/heroes");
  }

  const whitelistRows = await loadWhitelist(whitelistFile);
  for (const [index, row] of whitelistRows.entries()) {
    const decision = (row.decision ?? "").trim();
    if (!VALID_DECISIONS.has(decision)) {
      failures.push(`whitelist line ${index + 2}: invalid decision '${decision}' (allowed: keep_aram_only, parameterize_shared)`);
    }
  }
  const whitelistKeys = new Set<string>();
  for (const row of whitelistRows) {
    whitelistKeys.add(whitelistKey(row.kind ?? "", row.rule_or_macro ?? "", row.source_module ?? ""));
  }

  const aramRules = await parseRules(aramFile);
  const overlayPaths = allFiles
    .filter((filePath) => filePath.endsWith(".opy"))
    .filter((filePath) => isModeOverlay(path.relative(repoRoot, filePath)))
    .sort((a, b) => a.localeCompare(b));
  const overlayRulesByFile = new Map<string, Rule[]>();
  const overlayRules: Rule[] = [];
  for (const filePath of overlayPaths) {
    const parsed = await parseRules(filePath);
    overlayRulesByFile.set(path.relative(repoRoot, filePath), parsed);
    overlayRules.push(...parsed);
  }

  const otherByName = new Map<string, Array<{ norm: string; path: string }>>();
  for (const filePath of allFiles.filter((filePath) => filePath.endsWith(".opy"))) {
    const rel = path.relative(repoRoot, filePath);
    if (rel === "src/aram_overrides.opy" || isModeOverlay(rel)) {
      continue;
    }
    for (const rule of await parseRules(filePath)) {
      const bucket = otherByName.get(rule.name) ?? [];
      bucket.push({ norm: rule.norm, path: filePath });
      otherByName.set(rule.name, bucket);
    }
  }

  const aram = classifyRules(aramRules, otherByName);
  const overlay = classifyRules(overlayRules, otherByName);
  for (const rule of [...aram.exact, ...aram.diff]) {
    rule.sourceModule = pickSourceModule(rule, otherByName, aram.exact.includes(rule));
  }
  for (const rule of [...overlay.exact, ...overlay.diff]) {
    rule.sourceModule = pickSourceModule(rule, otherByName, overlay.exact.includes(rule));
  }

  function isWhitelisted(kind: string, rule: Rule): boolean {
    const source = rule.sourceModule?.trim() ?? "";
    return (
      whitelistKeys.has(whitelistKey(kind, rule.name, source)) ||
      whitelistKeys.has(whitelistKey(kind, rule.name, "*")) ||
      whitelistKeys.has(whitelistKey(kind, rule.name, ""))
    );
  }

  const unwhitelistedExact = aram.exact.filter((rule) => !isWhitelisted("rule_exact_duplicate", rule));
  const unwhitelistedDiff = aram.diff.filter((rule) => !isWhitelisted("rule_same_name_diff", rule));
  const unwhitelistedOverlayExact = overlay.exact.filter((rule) => !isWhitelisted("rule_exact_duplicate", rule));
  const unwhitelistedOverlayDiff = overlay.diff.filter((rule) => !isWhitelisted("rule_same_name_diff", rule));

  if (unwhitelistedExact.length > 0) {
    failures.push(`Found ${unwhitelistedExact.length} unwhitelisted exact duplicate rule(s) in src/aram_overrides.opy`);
  }
  if (unwhitelistedDiff.length > 0) {
    failures.push(`Found ${unwhitelistedDiff.length} unwhitelisted same-name-diff rule(s) in src/aram_overrides.opy`);
  }
  if (unwhitelistedOverlayExact.length > 0) {
    failures.push(
      `Found ${unwhitelistedOverlayExact.length} unwhitelisted exact duplicate rule(s) in hero overlays (${[...new Set(unwhitelistedOverlayExact.map((rule) => path.relative(repoRoot, rule.path)))].join(", ")})`,
    );
  }
  if (unwhitelistedOverlayDiff.length > 0) {
    failures.push(
      `Found ${unwhitelistedOverlayDiff.length} unwhitelisted same-name-diff rule(s) in hero overlays (${[...new Set(unwhitelistedOverlayDiff.map((rule) => path.relative(repoRoot, rule.path)))].join(", ")})`,
    );
  }

  const legacyRefs: string[] = [];
  for (const filePath of [...allFiles, ...(await listFiles(resolveRepo("tools"))).filter((entry) => entry.endsWith(".ts"))]) {
    const text = await fs.readFile(filePath, "utf8");
    if (LEGACY_REF_RE.test(text)) {
      legacyRefs.push(path.relative(repoRoot, filePath));
    }
  }
  const legacySrcRefs = legacyRefs.filter((entry) => entry.startsWith("src/"));
  if (legacySrcRefs.length > 0) {
    failures.push(`Found retired ARAM assembly references in src/: ${legacySrcRefs.join(", ")}`);
  }

  const exactLineSet = new Set(aram.exact.map((rule) => rule.line));
  const residualRuns: Rule[][] = [];
  for (let index = 0; index < aramRules.length; ) {
    if (!exactLineSet.has(aramRules[index]!.line)) {
      index += 1;
      continue;
    }
    let end = index;
    while (end + 1 < aramRules.length && exactLineSet.has(aramRules[end + 1]!.line)) {
      end += 1;
    }
    residualRuns.push(aramRules.slice(index, end + 1));
    index = end + 1;
  }
  const violatingRuns = residualRuns.filter((run) => run.length >= args.segmentMin);
  if (violatingRuns.length > 0) {
    failures.push(
      `Found ${violatingRuns.length} residual contiguous exact run(s) with length >= ${args.segmentMin} in src/aram_overrides.opy`,
    );
  }

  const candidateRows = [
    ...unwhitelistedExact.map((rule) => ["rule_exact_duplicate", rule.name, rule.sourceModule || "*", "TODO", "keep_aram_only", "TODO"].join("\t")),
    ...unwhitelistedDiff.map((rule) => ["rule_same_name_diff", rule.name, rule.sourceModule || "*", "TODO", "parameterize_shared", "TODO"].join("\t")),
    ...unwhitelistedOverlayExact.map((rule) => ["rule_exact_duplicate", rule.name, rule.sourceModule || "*", "TODO", "keep_aram_only", "TODO"].join("\t")),
    ...unwhitelistedOverlayDiff.map((rule) => ["rule_same_name_diff", rule.name, rule.sourceModule || "*", "TODO", "parameterize_shared", "TODO"].join("\t")),
  ];

  if (emitCandidatesFile) {
    await fs.mkdir(path.dirname(emitCandidatesFile), { recursive: true });
    await fs.writeFile(
      emitCandidatesFile,
      `kind\trule_or_macro\tsource_module\treason\tdecision\towner\n${candidateRows.join("\n")}${candidateRows.length > 0 ? "\n" : ""}`,
      "utf8",
    );
  }

  const reportLines: string[] = [];
  reportLines.push("# ARAM Overrides Duplicate Report", "", "## Summary", "");
  reportLines.push(`- \`src/aram_overrides.opy\` total rules: **${aramRules.length}**`);
  reportLines.push(`- \`src/aram_overrides.opy\` exact/diff/unique: **${aram.exact.length}/${aram.diff.length}/${aram.unique.length}**`);
  reportLines.push(`- Active overlays (\`src/**/aram*.opy\`, excluding entry/settings/protocol files) total rules: **${overlayRules.length}**`);
  reportLines.push(`- Active overlay exact/diff/unique: **${overlay.exact.length}/${overlay.diff.length}/${overlay.unique.length}**`);
  reportLines.push(`- Residual contiguous exact runs in aram_overrides: **${residualRuns.length}**`);
  reportLines.push(`- Residual runs with length >= ${args.segmentMin}: **${violatingRuns.length}**`);
  reportLines.push(`- Retired assembly references in \`src/\`: **${legacySrcRefs.length}**`);
  reportLines.push(`- Whitelist file: \`${path.relative(repoRoot, whitelistFile)}\``);
  reportLines.push(`- Whitelist rows: **${whitelistRows.length}**`);
  reportLines.push(`- Unwhitelisted aram exact/diff: **${unwhitelistedExact.length}/${unwhitelistedDiff.length}**`);
  reportLines.push(`- Unwhitelisted hero overlay exact/diff: **${unwhitelistedOverlayExact.length}/${unwhitelistedOverlayDiff.length}**`);
  if (emitCandidatesFile) {
    reportLines.push(`- Candidate output: \`${path.relative(repoRoot, emitCandidatesFile)}\` (${candidateRows.length} rows)`);
  }
  reportLines.push(`- Check mode: **${args.check ? "ON" : "OFF"}**`, "", "## Active Overlay Coverage", "");
  for (const [rel, rules] of overlayRulesByFile.entries()) {
    reportLines.push(`- \`${rel}\`: ${rules.length} rules`);
  }
  reportLines.push("", "## Retired Assembly Reference Scan", "");
  if (legacyRefs.length > 0) {
    for (const ref of legacyRefs.sort((a, b) => a.localeCompare(b))) {
      reportLines.push(`- \`${ref}\``);
    }
  } else {
    reportLines.push("- None");
  }
  reportLines.push("", "## Residual Exact Runs", "");
  if (residualRuns.length > 0) {
    for (const run of residualRuns) {
      reportLines.push(`- lines ${run[0]!.line}-${run[run.length - 1]!.end}: ${run.length} rules, \`${run[0]!.name}\` -> \`${run[run.length - 1]!.name}\``);
    }
  } else {
    reportLines.push("- None");
  }

  const sections: Array<[string, Rule[]]> = [
    ["Unwhitelisted Exact Duplicates (aram_overrides)", unwhitelistedExact],
    ["Unwhitelisted Same-Name-Diff (aram_overrides)", unwhitelistedDiff],
    ["Unwhitelisted Exact Duplicates (hero overlays)", unwhitelistedOverlayExact],
    ["Unwhitelisted Same-Name-Diff (hero overlays)", unwhitelistedOverlayDiff],
  ];
  for (const [title, rules] of sections) {
    reportLines.push("", `## ${title}`, "");
    if (rules.length > 0) {
      for (const rule of rules) {
        reportLines.push(`- \`${path.relative(repoRoot, rule.path)}:${rule.line}\` \`${rule.name}\` (source: \`${rule.sourceModule || "*"}\`)`);
      }
    } else {
      reportLines.push("- None");
    }
  }
  reportLines.push("", "## Validation", "");
  if (failures.length > 0) {
    for (const failure of failures) {
      reportLines.push(`- FAIL: ${failure}`);
    }
  } else {
    reportLines.push("- PASS: all validations passed");
  }

  await fs.mkdir(path.dirname(reportFile), { recursive: true });
  await fs.writeFile(reportFile, `${reportLines.join("\n")}\n`, "utf8");

  console.log(`Report written: ${path.relative(repoRoot, reportFile)}`);
  console.log(
    `Counts => aram total/exact/diff/unique: ${aramRules.length}/${aram.exact.length}/${aram.diff.length}/${aram.unique.length}, active overlays exact/diff/unique: ${overlay.exact.length}/${overlay.diff.length}/${overlay.unique.length}, residual exact runs >= ${args.segmentMin}: ${violatingRuns.length}, retired src refs: ${legacySrcRefs.length}, unwhitelisted aram/overlay exact-diff: ${unwhitelistedExact.length}/${unwhitelistedDiff.length}, ${unwhitelistedOverlayExact.length}/${unwhitelistedOverlayDiff.length}`,
  );
  if (emitCandidatesFile) {
    console.log(`Candidates written: ${path.relative(repoRoot, emitCandidatesFile)} (${candidateRows.length} rows)`);
  }
  if (failures.length > 0) {
    console.log("Validation failures:");
    for (const failure of failures) {
      console.log(`- ${failure}`);
    }
  }
  if (args.check && failures.length > 0) {
    process.exit(1);
  }
}

main().catch((error: Error) => {
  console.error(error.message);
  process.exit(1);
});
