#!/usr/bin/env -S node --import tsx

import fs from "node:fs/promises";
import path from "node:path";
import process from "node:process";
import { listOpyFiles, readText, relRepo, repoRoot, resolveRepo, writeText } from "./lib/runtime.js";

type Mode = "main" | "aram";
type Category =
  | "ow2_reference_value"
  | "absolute_pve_target"
  | "relative_pve_modifier"
  | "project_only_mechanic_constant"
  | "runtime_workshop_setting";

type Definition = {
  name: string;
  value: string;
  line: number;
  active: boolean;
};

type SourceLocation = {
  file: string;
  line: number;
};

type SettingEntry = SourceLocation & {
  mode: Mode;
  team: string;
  hero: string;
  field: string;
  value: string;
  isNumericLiteral: boolean;
  category: Category;
  referenceTokens: string[];
  targetTokens: string[];
};

type MainDerivedSetting = SettingEntry & {
  functionName: "ratioPercent" | "ultGenPercent";
  expressionArguments: string[];
  referenceToken: string | null;
  targetToken: string | null;
  canonicalReference: string | null;
  referenceResolved: boolean;
  aramRepresentations: SettingEntry[];
};

type WorkshopSettingSource = {
  file: string;
  mode: Mode;
  hero: string;
  entries: Array<SourceLocation & {
    factory: string;
    expression: string;
  }>;
};

type AuditInventory = {
  schemaVersion: 1;
  generatedBy: string;
  generatedFrom: string[];
  semantics: Record<Category, string>;
  summary: {
    activeOw2ReferenceDefinitions: number;
    commentedOw2ReferenceDefinitions: number;
    directOw2Consumers: number;
    duplicateBaselineFacts: number;
    consumedDuplicateBaselineFacts: number;
    mainDerivedSettings: number;
    aramSettingEntries: number;
    aramDirectNumericSettings: number;
    heroWorkshopSettingEntries: number;
    missingProjectConsumedReferences: number;
    unusedOw2ReferenceDefinitions: number;
    semanticReviewItems: number;
  };
  coverage: {
    files: Array<{
      path: string;
      role: string;
      inspected: boolean;
      relevantEntries: number;
    }>;
    mainHeroes: string[];
    aramHeroes: string[];
  };
  duplicateBaselineFacts: Array<{
    canonicalReference: string;
    legacyName: string;
    referenceValue: string;
    legacyValue: string;
    sameValue: boolean;
    referenceActive: boolean;
    referenceLine: number | null;
    legacyLine: number;
    consumers: SourceLocation[];
  }>;
  baselineFields: Array<{
    id: string;
    hero: string;
    field: string;
    team: string;
    category: Category;
    main: MainDerivedSetting;
    aram: SettingEntry[];
    canonicalReference: string | null;
    duplicateBaselineNames: string[];
    migrationNotes: string[];
  }>;
  directOw2Consumers: Array<{
    canonicalReference: string;
    value: string;
    consumers: SourceLocation[];
  }>;
  missingProjectConsumedReferences: Array<{
    id: string;
    hero: string;
    field: string;
    team: string;
    referenceToken: string | null;
    source: SourceLocation;
    reason: string;
  }>;
  unusedOw2ReferenceDefinitions: Definition[];
  aramDirectNumericSettings: SettingEntry[];
  heroWorkshopSettingSources: WorkshopSettingSource[];
  semanticReviewRequired: Array<{
    id: string;
    category: "aram_direct_literal" | "divergent_duplicate" | "missing_reference";
    hero: string;
    field: string;
    source: SourceLocation;
    value: string;
    reason: string;
  }>;
};

const semantics: Record<Category, string> = {
  ow2_reference_value: "Upstream OW2 baseline/reference fact; it is not a PvE tuning decision.",
  absolute_pve_target: "An intended PvE value expressed as an absolute target and converted to a Workshop percentage.",
  relative_pve_modifier: "An intentional relationship to the selected OW2 reference; it must not be rewritten as an absolute target without review.",
  project_only_mechanic_constant: "A project mechanic without a meaningful vanilla baseline.",
  runtime_workshop_setting: "A user-configurable Workshop setting that must remain runtime-controlled.",
};

const sourceFiles = [
  "src/constants/ow2_hero_defaults.opy",
  "src/constants/player_constants.opy",
  "src/constants/hero_balance_constants.opy",
  "src/modules/prelude/settings.opy",
  "src/aram_settings.opy",
  "src/heroes/**/settings*.opy",
  "src/heroes/**/init.opy",
  "src/heroes/**/rules.opy",
  "src/heroes/**/aram.opy",
];

const numericLiteralPattern = /^[-+]?\d+(?:\.\d+)?$/;
const uppercaseTokenPattern = /\b[A-Z][A-Z0-9_]+\b/g;
const heroFieldPattern = /(?:cooldown|duration|health|damage|healing|ammo|projectile|movement|ult|regen|rate|quantity|radius|speed|cost|knockback|impulse|shield|armor|range)/i;

function parseArgs(argv: string[]): { write: boolean; check: boolean } {
  const args = { write: false, check: false };
  for (const arg of argv) {
    if (arg === "--") continue;
    if (arg === "--write") args.write = true;
    else if (arg === "--check") args.check = true;
    else if (arg === "-h" || arg === "--help") {
      console.log("Usage: tools/audit-hero-balance.ts [--write|--check]");
      process.exit(0);
    } else {
      throw new Error(`Unknown argument: ${arg}`);
    }
  }
  if (args.write && args.check) throw new Error("Choose only one of --write or --check");
  if (!args.write && !args.check) args.check = true;
  return args;
}

function parseDefinitions(file: string): Definition[] {
  return file.split(/\r?\n/).flatMap((line, index) => {
    const active = line.match(/^#!define\s+([A-Z0-9_]+)\s+(.+)$/);
    if (active) return [{ name: active[1]!, value: active[2]!.trim(), line: index + 1, active: true } as Definition];
    const commented = line.match(/^#\s*!define\s+([A-Z0-9_]+)\s+(.+)$/);
    if (commented) return [{ name: commented[1]!, value: commented[2]!.trim(), line: index + 1, active: false } as Definition];
    return [] as Definition[];
  });
}

function parseDefinitionMap(definitions: Definition[]): Map<string, Definition> {
  return new Map(definitions.map((definition) => [definition.name, definition]));
}

function tokensIn(value: string): string[] {
  return [...new Set(value.match(uppercaseTokenPattern) ?? [])];
}

function splitArguments(value: string): string[] {
  const open = value.indexOf("(");
  const close = value.lastIndexOf(")");
  if (open < 0 || close <= open) return [];
  const result: string[] = [];
  let current = "";
  let depth = 0;
  for (const char of value.slice(open + 1, close)) {
    if (char === "(") depth += 1;
    if (char === ")") depth -= 1;
    if (char === "," && depth === 0) {
      result.push(current.trim());
      current = "";
    } else current += char;
  }
  if (current.trim()) result.push(current.trim());
  return result;
}

function indentation(line: string): number {
  return line.match(/^\s*/)?.[0].length ?? 0;
}

function parseSettingEntries(file: string, mode: Mode): SettingEntry[] {
  const lines = file.split(/\r?\n/);
  const stack: Array<{ indent: number; key: string }> = [];
  const entries: SettingEntry[] = [];
  for (let index = 0; index < lines.length; index += 1) {
    const line = lines[index]!;
    const trimmed = line.trim();
    const indent = indentation(line);
    if (trimmed.startsWith("}")) {
      while (stack.length > 0 && stack[stack.length - 1]!.indent >= indent) stack.pop();
    }
    const object = line.match(/^(\s*)"([^"\n]+)"\s*:\s*\{$/);
    if (object) {
      while (stack.length > 0 && stack[stack.length - 1]!.indent >= indent) stack.pop();
      stack.push({ indent, key: object[2]! });
      continue;
    }
    const property = line.match(/^\s*"([^"\n]+)"\s*:\s*(.*?)(?:,)?\s*$/);
    if (!property) continue;
    const team = [...stack].reverse().find((item) => ["team1", "team2", "allTeams"].includes(item.key))?.key;
    const teamIndex = team ? stack.findIndex((item) => item.key === team) : -1;
    const hero = teamIndex >= 0 ? stack[teamIndex + 1]?.key : undefined;
    if (!team || !hero) continue;
    const value = property[2]!.trim();
    const field = property[1]!;
    const category: Category = mode === "aram" ? "runtime_workshop_setting" : "project_only_mechanic_constant";
    entries.push({
      mode,
      team,
      hero,
      field,
      value,
      file: "",
      line: index + 1,
      isNumericLiteral: numericLiteralPattern.test(value),
      category,
      referenceTokens: tokensIn(value),
      targetTokens: tokensIn(value),
    });
  }
  return entries;
}

function withFile<T extends SourceLocation>(entries: T[], file: string): T[] {
  return entries.map((entry) => ({ ...entry, file }));
}

function isBaselineField(field: string): boolean {
  return field.endsWith("%") && heroFieldPattern.test(field);
}

function parseMainDerivedSettings(file: string, aramEntries: SettingEntry[], ow2: Map<string, Definition>, player: Map<string, Definition>): MainDerivedSetting[] {
  return parseSettingEntries(file, "main")
    .filter((entry) => entry.value.includes("ratioPercent(") || entry.value.includes("ultGenPercent("))
    .map((entry) => {
      const functionName = entry.value.includes("ratioPercent(") ? "ratioPercent" : "ultGenPercent";
      const expressionArguments = splitArguments(entry.value);
      const referenceToken = functionName === "ratioPercent" ? tokensIn(expressionArguments[1] ?? "").find(Boolean) ?? null : tokensIn(expressionArguments[0] ?? "").find(Boolean) ?? null;
      const targetToken = functionName === "ratioPercent" ? tokensIn(expressionArguments[0] ?? "").find(Boolean) ?? null : tokensIn(expressionArguments[1] ?? "").find(Boolean) ?? null;
      const directReference = referenceToken?.startsWith("OW2_") ? referenceToken : null;
      const aliasReference = referenceToken && ow2.has(`OW2_${referenceToken}`) ? `OW2_${referenceToken}` : null;
      const canonicalReference = directReference ?? aliasReference;
      const referenceResolved = canonicalReference !== null && ow2.get(canonicalReference)?.active === true;
      const aramRepresentations = aramEntries.filter((candidate) => candidate.hero === entry.hero && candidate.field === entry.field);
      return {
        ...entry,
        category: "absolute_pve_target",
        functionName,
        expressionArguments,
        referenceToken,
        targetToken,
        canonicalReference,
        referenceResolved,
        referenceTokens: tokensIn(entry.value),
        targetTokens: targetToken ? [targetToken] : [],
        aramRepresentations,
      };
    });
}

function parseWorkshopSettingSources(files: string[], contents: Map<string, string>): WorkshopSettingSource[] {
  return files
    .filter((file) => /^src\/heroes\/[^/]+\/settings(?:\.aram)?\.opy$/.test(file))
    .map((file) => {
      const parts = file.split("/");
      const hero = parts[2]!;
      const mode: Mode = file.endsWith(".aram.opy") ? "aram" : "main";
      const entries = contents.get(file)!.split(/\r?\n/).flatMap((line, index) => {
        const match = line.match(/\b(createWorkshopSetting(?:Int|Float|Bool|String))\s*\(/);
        return match ? [{ file, line: index + 1, factory: match[1]!, expression: line.trim() }] : [];
      });
      return { file, mode, hero, entries };
    });
}

function sourceLocations(values: string[]): SourceLocation[] {
  return values.map((value) => {
    const match = value.match(/^(.*):(\d+)$/)!;
    return { file: match[1]!, line: Number(match[2]) };
  });
}

function findReferences(name: string, contents: Map<string, string>): SourceLocation[] {
  const pattern = new RegExp(`\\b${name.replace(/[.*+?^${}()|[\\]\\]/g, "\\\\$&")}\\b`);
  const locations: SourceLocation[] = [];
  for (const [file, content] of contents) {
    if (file === "src/constants/ow2_hero_defaults.opy") continue;
    content.split(/\r?\n/).forEach((line, index) => {
      if (/^\s*#/.test(line) || /^#!define\s+/.test(line)) return;
      if (pattern.test(line)) locations.push({ file, line: index + 1 });
    });
  }
  return locations;
}

function buildReport(inventory: AuditInventory): string {
  const lines: string[] = [
    "# Hero balance reference coverage audit",
    "",
    "本报告由 `tools/audit-hero-balance.ts` 从当前源码确定性生成，对应 GitHub Issue #78。它只记录现状，不修改任何玩法数值。完整逐项 inventory 在同目录的 JSON 文件中。",
    "",
    "## 结论摘要",
    "",
    `- 启用的 OW2_* reference 定义：${inventory.summary.activeOw2ReferenceDefinitions}；注释掉的候选定义：${inventory.summary.commentedOw2ReferenceDefinitions}。`,
    `- Main 中直接使用 OW2_*：${inventory.summary.directOw2Consumers} 个字段；另有 ${inventory.summary.consumedDuplicateBaselineFacts} 个被消费的非命名空间重复基线事实（总记录 ${inventory.summary.duplicateBaselineFacts} 个）。`,
    `- Main 中通过 ratioPercent/ultGenPercent 形成的基线相关 settings：${inventory.summary.mainDerivedSettings} 条。`,
    `- ARAM settings 条目：${inventory.summary.aramSettingEntries} 条，其中直接数字：${inventory.summary.aramDirectNumericSettings} 条。`,
    `- 英雄 runtime Workshop setting 工厂调用：${inventory.summary.heroWorkshopSettingEntries} 条。`,
    `- 需要在迁移前人工确认的项目：${inventory.summary.semanticReviewItems} 条；缺失 reference：${inventory.summary.missingProjectConsumedReferences} 条。`,
    "",
    "## 分类口径",
    "",
    ...Object.entries(inventory.semantics).map(([category, description]) => `- **${category}**：${description}`),
    "",
    "## 文件覆盖",
    "",
    "| 文件/范围 | 角色 | 相关条目 |",
    "| --- | --- | ---: |",
    ...inventory.coverage.files.map((file) => `| \`${file.path}\` | ${file.role} | ${file.relevantEntries} |`),
    "",
    "## 重复基线事实",
    "",
    "`player_constants.opy` 中以下名称与 `OW2_*` reference 同名但缺少命名空间；即使数值当前相同，也形成了可漂移的第二来源。",
    "",
    "| legacy 名称 | canonical reference | 当前值 | 是否相同 | 消费位置 |",
    "| --- | --- | ---: | :---: | --- |",
    ...inventory.duplicateBaselineFacts.map((item) => `| \`${item.legacyName}\` | \`${item.canonicalReference}\` | \`${item.legacyValue}\` | ${item.sameValue ? "是" : "否"} | ${item.consumers.map((location) => `\`${location.file}:${location.line}\``).join(", ") || "未直接消费"} |`),
    "",
    "## Main 基线相关 settings inventory",
    "",
    "每一行代表一个当前 Main 的 `ratioPercent` 或 `ultGenPercent` 消费；ARAM 对应条目、canonical reference、target 来源和迁移备注均在 JSON 的 `baselineFields` 中保留。",
    "",
    "| Team | Hero | Field | Category | Reference | Target | ARAM 表示 |",
    "| --- | --- | --- | --- | --- | --- | --- |",
    ...inventory.baselineFields.map((item) => `| ${item.team} | ${item.hero} | \`${item.field}\` | ${item.category} | \`${item.canonicalReference ?? "缺失"}\` | \`${item.main.targetToken ?? "字面/未知"}\` | ${item.aram.map((entry) => `\`${entry.team}:${entry.value}\``).join(", ") || "未配置"} |`),
    "",
    "## 缺失 reference 与人工设计审查",
    "",
    "这些项目不能仅凭现有代码安全地归入新的 reference/target/modifier 层，#80 迁移前必须显式决定。",
    "",
    "| 类别 | Hero | Field | 来源 | 当前值 | 原因 |",
    "| --- | --- | --- | --- | --- | --- |",
    ...inventory.semanticReviewRequired.map((item) => `| ${item.category} | ${item.hero} | \`${item.field}\` | \`${item.source.file}:${item.source.line}\` | \`${item.value}\` | ${item.reason} |`),
    "",
    "## 未使用 reference",
    "",
    "`unusedOw2ReferenceDefinitions` 是当前既没有直接消费、也没有通过重复 alias 消费的启用定义；#79 应只把项目实际消费的子集纳入 canonical snapshot，避免把未使用字段误当作项目契约。完整列表见 JSON。",
    "",
    `共 ${inventory.unusedOw2ReferenceDefinitions.length} 个。`,
    "",
    "## 迁移边界",
    "",
    "- 保留 Main/ARAM 的独立 tuning；审计不把 ARAM 的直接百分比自动解释为绝对 target。",
    "- `src/heroes/**/settings*.opy` 的 `createWorkshopSetting*` 属于 runtime Workshop setting，不能折叠进 OW2 reference。",
    "- 只有在 #79 reference schema 和本报告的人工审查项明确后，#80 才能删除重复常数并迁移消费者。",
  ];
  return `${lines.join("\n")}\n`;
}

async function buildInventory(): Promise<AuditInventory> {
  const opyFiles = listOpyFiles(resolveRepo("src")).map(relRepo);
  const contents = new Map<string, string>();
  for (const file of opyFiles) contents.set(file, await readText(resolveRepo(file)));

  const ow2Definitions = parseDefinitions(contents.get("src/constants/ow2_hero_defaults.opy")!);
  const playerDefinitions = parseDefinitions(contents.get("src/constants/player_constants.opy")!);
  const ow2 = parseDefinitionMap(ow2Definitions);
  const player = parseDefinitionMap(playerDefinitions);
  const aramEntries = withFile(parseSettingEntries(contents.get("src/aram_settings.opy")!, "aram"), "src/aram_settings.opy");
  const mainEntries = withFile(parseSettingEntries(contents.get("src/modules/prelude/settings.opy")!, "main"), "src/modules/prelude/settings.opy");
  const mainDerivedSettings = parseMainDerivedSettings(contents.get("src/modules/prelude/settings.opy")!, aramEntries, ow2, player).map((entry) => ({ ...entry, file: "src/modules/prelude/settings.opy" }));
  const workshopSettingSources = parseWorkshopSettingSources(opyFiles, contents);

  const duplicateBaselineFacts = ow2Definitions
    .filter((definition) => definition.name.startsWith("OW2_") && player.has(definition.name.slice(4)))
    .map((definition) => {
      const legacyName = definition.name.slice(4);
      const legacy = player.get(legacyName)!;
      return {
        canonicalReference: definition.name,
        legacyName,
        referenceValue: definition.value,
        legacyValue: legacy.value,
        sameValue: definition.value === legacy.value,
        referenceActive: definition.active,
        referenceLine: definition.line,
        legacyLine: legacy.line,
        consumers: findReferences(legacyName, contents),
      };
    })
    .sort((a, b) => a.legacyName.localeCompare(b.legacyName));

  const duplicateNamesByReference = new Map(duplicateBaselineFacts.map((item) => [item.canonicalReference, item.legacyName]));
  const baselineFields = mainDerivedSettings.map((main) => {
    const duplicateBaselineNames = main.referenceToken && player.has(main.referenceToken) ? [main.referenceToken] : [];
    const migrationNotes = [...(main.referenceResolved ? [] : ["reference token cannot be resolved to an active OW2 definition"]), ...(duplicateBaselineNames.length > 0 ? ["consumer currently uses a non-namespaced player constant"] : [])];
    return {
      id: `${main.team}.${main.hero}.${main.field}`,
      hero: main.hero,
      field: main.field,
      team: main.team,
      category: main.category,
      main,
      aram: main.aramRepresentations,
      canonicalReference: main.canonicalReference,
      duplicateBaselineNames,
      migrationNotes,
    };
  });

  const directOw2Consumers = ow2Definitions
    .filter((definition) => definition.active && definition.name.startsWith("OW2_"))
    .map((definition) => ({ canonicalReference: definition.name, value: definition.value, consumers: findReferences(definition.name, contents) }))
    .filter((item) => item.consumers.length > 0);

  const missingProjectConsumedReferences = baselineFields
    .filter((field) => !field.main.referenceResolved)
    .map((field) => ({
      id: field.id,
      hero: field.hero,
      field: field.field,
      team: field.team,
      referenceToken: field.main.referenceToken,
      source: { file: field.main.file, line: field.main.line },
      reason: "Main derives a Workshop percentage from a token that is not an active canonical OW2 definition; do not migrate it without deciding whether it is an absolute target or a relative modifier.",
    }));

  const consumedCanonicalReferences = new Set(directOw2Consumers.map((item) => item.canonicalReference));
  for (const duplicate of duplicateBaselineFacts) {
    if (duplicate.consumers.length > 0 && duplicate.referenceActive) consumedCanonicalReferences.add(duplicate.canonicalReference);
  }
  const unusedOw2ReferenceDefinitions = ow2Definitions.filter((definition) => definition.active && definition.name.startsWith("OW2_") && !consumedCanonicalReferences.has(definition.name));
  const aramDirectNumericSettings = aramEntries.filter((entry) => entry.isNumericLiteral && isBaselineField(entry.field));
  const semanticReviewRequired: AuditInventory["semanticReviewRequired"] = [
    ...missingProjectConsumedReferences.map((item) => ({ id: item.id, category: "missing_reference" as const, hero: item.hero, field: item.field, source: item.source, value: item.referenceToken ?? "unknown", reason: item.reason })),
    ...duplicateBaselineFacts.filter((item) => !item.sameValue).map((item) => ({ id: `duplicate.${item.legacyName}`, category: "divergent_duplicate" as const, hero: item.legacyName.split("_")[0] ?? "unknown", field: item.legacyName, source: { file: "src/constants/player_constants.opy", line: item.legacyLine }, value: item.legacyValue, reason: `legacy value differs from ${item.canonicalReference} (${item.referenceValue}); this may be a target or a stale duplicate` })),
    ...aramDirectNumericSettings.map((entry) => ({ id: `aram.${entry.team}.${entry.hero}.${entry.field}`, category: "aram_direct_literal" as const, hero: entry.hero, field: entry.field, source: { file: entry.file, line: entry.line }, value: entry.value, reason: "ARAM stores a balance-sensitive Workshop percentage directly; semantic intent cannot be inferred from the literal alone" })),
  ];

  const countEntries = (file: string): number => {
    if (file === "src/constants/ow2_hero_defaults.opy") return ow2Definitions.length;
    if (file === "src/constants/player_constants.opy") return duplicateBaselineFacts.length;
    if (file === "src/modules/prelude/settings.opy") return mainEntries.length;
    if (file === "src/aram_settings.opy") return aramEntries.length;
    return 0;
  };

  const coverageFiles = [
    { path: "src/constants/ow2_hero_defaults.opy", role: "当前 OW2 reference 常数文件", inspected: true, relevantEntries: countEntries("src/constants/ow2_hero_defaults.opy") },
    { path: "src/constants/player_constants.opy", role: "项目常数、目标和重复 baseline 别名", inspected: true, relevantEntries: countEntries("src/constants/player_constants.opy") },
    { path: "src/constants/hero_balance_constants.opy", role: "Main/ARAM 最终 Workshop 百分比及项目机制常数", inspected: true, relevantEntries: 0 },
    { path: "src/modules/prelude/settings.opy", role: "Main Workshop settings consumer", inspected: true, relevantEntries: mainDerivedSettings.length },
    { path: "src/aram_settings.opy", role: "ARAM Workshop settings consumer", inspected: true, relevantEntries: aramEntries.length },
    { path: "src/heroes/**/settings*.opy", role: "runtime Workshop setting acquisition", inspected: true, relevantEntries: workshopSettingSources.reduce((sum, source) => sum + source.entries.length, 0) },
    { path: "src/heroes/**/init.opy", role: "hero init consumers inspected for reference usage", inspected: true, relevantEntries: 0 },
    { path: "src/heroes/**/rules.opy", role: "hero rule consumers inspected for reference usage", inspected: true, relevantEntries: 0 },
    { path: "src/heroes/**/aram.opy", role: "ARAM hero rule consumers inspected for reference usage", inspected: true, relevantEntries: 0 },
  ];

  return {
    schemaVersion: 1,
    generatedBy: "tools/audit-hero-balance.ts",
    generatedFrom: sourceFiles,
    semantics,
    summary: {
      activeOw2ReferenceDefinitions: ow2Definitions.filter((definition) => definition.active && definition.name.startsWith("OW2_")).length,
      commentedOw2ReferenceDefinitions: ow2Definitions.filter((definition) => !definition.active && definition.name.startsWith("OW2_")).length,
      directOw2Consumers: directOw2Consumers.length,
      duplicateBaselineFacts: duplicateBaselineFacts.length,
      consumedDuplicateBaselineFacts: duplicateBaselineFacts.filter((item) => item.referenceActive && item.consumers.length > 0).length,
      mainDerivedSettings: mainDerivedSettings.length,
      aramSettingEntries: aramEntries.length,
      aramDirectNumericSettings: aramDirectNumericSettings.length,
      heroWorkshopSettingEntries: workshopSettingSources.reduce((sum, source) => sum + source.entries.length, 0),
      missingProjectConsumedReferences: missingProjectConsumedReferences.length,
      unusedOw2ReferenceDefinitions: unusedOw2ReferenceDefinitions.length,
      semanticReviewItems: semanticReviewRequired.length,
    },
    coverage: {
      files: coverageFiles,
      mainHeroes: [...new Set(mainEntries.map((entry) => entry.hero))].sort((a, b) => a.localeCompare(b)),
      aramHeroes: [...new Set(aramEntries.map((entry) => entry.hero))].sort((a, b) => a.localeCompare(b)),
    },
    duplicateBaselineFacts,
    baselineFields,
    directOw2Consumers,
    missingProjectConsumedReferences,
    unusedOw2ReferenceDefinitions,
    aramDirectNumericSettings,
    heroWorkshopSettingSources: workshopSettingSources,
    semanticReviewRequired,
  };
}

function serialize(value: unknown): string {
  return `${JSON.stringify(value, null, 2)}\n`;
}

async function main(): Promise<void> {
  const args = parseArgs(process.argv.slice(2));
  const inventoryPath = resolveRepo("data/ow2/hero-balance-audit.json");
  const reportPath = resolveRepo("docs/hero-balance-reference-audit.md");
  const inventory = await buildInventory();
  const serialized = serialize(inventory);
  const report = buildReport(inventory);
  if (args.write) {
    await writeText(inventoryPath, serialized);
    await writeText(reportPath, report);
    console.log(`Wrote ${relRepo(inventoryPath)} and ${relRepo(reportPath)}`);
    console.log(JSON.stringify(inventory.summary));
    return;
  }
  let existing: string;
  try {
    existing = await readText(inventoryPath);
  } catch {
    throw new Error(`Missing ${relRepo(inventoryPath)}; run with --write first`);
  }
  if (existing !== serialized) throw new Error(`${relRepo(inventoryPath)} is out of date; run with --write`);
  let existingReport: string;
  try {
    existingReport = await readText(reportPath);
  } catch {
    throw new Error(`Missing ${relRepo(reportPath)}; run with --write first`);
  }
  if (existingReport !== report) throw new Error(`${relRepo(reportPath)} is out of date; run with --write`);
  console.log(`Audit inventory is current: ${relRepo(inventoryPath)}`);
  console.log(JSON.stringify(inventory.summary));
}

main().catch((error: Error) => {
  console.error(error.message);
  process.exit(1);
});
