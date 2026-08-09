#!/usr/bin/env -S node --import tsx

import fs from "node:fs/promises";
import process from "node:process";
import { readText, resolveRepo, writeText } from "./lib/runtime.js";

type Ruleset = "5v5" | "6v6" | "shared" | "unknown";

type ReferenceEntry = {
  constant: string;
  hero: string;
  field: string;
  value?: number;
  expression?: string;
  unit: string;
  ruleset: Ruleset;
  source: {
    type: string;
    snapshot: string;
  };
  provenanceNote: string;
};

type Dataset = {
  schemaVersion: number;
  snapshot: {
    id: string;
    effectiveDate: string;
    lastVerified: string | null;
    ruleset: Ruleset;
    verificationStatus: string;
    source: {
      type: string;
      identifier: string;
      url: string;
    };
    provenanceNotes: string[];
  };
  generation: {
    referenceRuleset: Ruleset;
    output: string;
    ordering: string;
  };
  references: ReferenceEntry[];
};

type Audit = {
  duplicateBaselineFacts: Array<{
    canonicalReference: string | null;
    referenceActive: boolean;
    consumers: unknown[];
  }>;
  directOw2Consumers: Array<{
    canonicalReference: string | null;
  }>;
};

const datasetPath = "data/ow2/reference-snapshot.json";
const auditPath = "data/ow2/hero-balance-audit.json";
const allowedRulesets = new Set<Ruleset>(["5v5", "6v6", "shared", "unknown"]);

function parseArgs(argv: string[]): { write: boolean; check: boolean } {
  const args = { write: false, check: false };
  for (const arg of argv) {
    if (arg === "--") continue;
    if (arg === "--write") args.write = true;
    else if (arg === "--check") args.check = true;
    else if (arg === "-h" || arg === "--help") {
      console.log("Usage: tools/generate-ow2-reference.ts [--write|--check]");
      process.exit(0);
    } else {
      throw new Error(`Unknown argument: ${arg}`);
    }
  }
  if (args.write && args.check) throw new Error("Choose only one of --write or --check");
  if (!args.write && !args.check) args.check = true;
  return args;
}

function compareStrings(left: string, right: string): number {
  return left < right ? -1 : left > right ? 1 : 0;
}

function validateDataset(dataset: Dataset): void {
  if (dataset.schemaVersion !== 1) throw new Error("unsupported reference snapshot schemaVersion");
  if (!dataset.snapshot?.id || !dataset.snapshot.effectiveDate || !dataset.snapshot.verificationStatus) {
    throw new Error("snapshot metadata must include id, effectiveDate, and verificationStatus");
  }
  if (!allowedRulesets.has(dataset.snapshot.ruleset)) throw new Error(`unsupported snapshot ruleset: ${dataset.snapshot.ruleset}`);
  if (!dataset.snapshot.source?.type || !dataset.snapshot.source.identifier || !/^https:\/\//.test(dataset.snapshot.source.url)) {
    throw new Error("snapshot source must include type, identifier, and an https URL");
  }
  if (dataset.generation.referenceRuleset !== dataset.snapshot.ruleset) {
    throw new Error("generation.referenceRuleset must match snapshot.ruleset");
  }
  if (dataset.generation.output !== "src/constants/ow2_hero_defaults.opy") {
    throw new Error(`unexpected generated output: ${dataset.generation.output}`);
  }
  if (dataset.generation.ordering !== "hero, field, constant") {
    throw new Error("generation.ordering must be hero, field, constant");
  }
  if (!Array.isArray(dataset.references) || dataset.references.length === 0) {
    throw new Error("reference snapshot must contain at least one reference entry");
  }

  const constants = new Set<string>();
  const fields = new Set<string>();
  for (const reference of dataset.references) {
    if (!/^OW2_[A-Z0-9_]+$/.test(reference.constant)) throw new Error(`invalid reference constant: ${reference.constant}`);
    if (constants.has(reference.constant)) throw new Error(`duplicate reference constant: ${reference.constant}`);
    constants.add(reference.constant);
    if (!reference.hero || !reference.field || !reference.unit || !reference.provenanceNote) {
      throw new Error(`reference ${reference.constant} is missing hero, field, unit, or provenanceNote`);
    }
    if (!allowedRulesets.has(reference.ruleset)) throw new Error(`unsupported ruleset for ${reference.constant}: ${reference.ruleset}`);
    if (reference.source?.type !== "snapshot" || reference.source.snapshot !== dataset.snapshot.id) {
      throw new Error(`reference ${reference.constant} must point to its snapshot provenance`);
    }
    const hasValue = typeof reference.value === "number" && Number.isFinite(reference.value);
    const hasExpression = typeof reference.expression === "string" && reference.expression.trim().length > 0;
    if (hasValue === hasExpression) throw new Error(`${reference.constant} must have exactly one numeric value or expression`);
    const fieldKey = `${reference.hero}.${reference.field}.${reference.ruleset}`;
    if (fields.has(fieldKey)) throw new Error(`duplicate hero/field/ruleset entry: ${fieldKey}`);
    fields.add(fieldKey);
  }

  const configuredRuleset = dataset.generation.referenceRuleset;
  const fieldKeys = [...new Set(dataset.references.map((reference) => `${reference.hero}.${reference.field}`))];
  for (const fieldKey of fieldKeys) {
    const candidates = dataset.references.filter((reference) => `${reference.hero}.${reference.field}` === fieldKey && (reference.ruleset === configuredRuleset || reference.ruleset === "shared"));
    if (candidates.length !== 1) {
      throw new Error(`ambiguous or missing ${configuredRuleset} reference for ${fieldKey}; candidates=${candidates.length}`);
    }
  }

  const sorted = [...dataset.references].sort((left, right) => compareStrings(left.hero, right.hero) || compareStrings(left.field, right.field) || compareStrings(left.constant, right.constant));
  for (let index = 0; index < sorted.length; index += 1) {
    if (sorted[index]!.constant !== dataset.references[index]!.constant) {
      throw new Error("reference entries are not in deterministic hero, field, constant order");
    }
  }
}

function displayHero(hero: string): string {
  return hero
    .split("_")
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join(" ");
}

function renderValue(reference: ReferenceEntry): string {
  if (reference.expression) return reference.expression;
  return String(reference.value);
}

function renderGeneratedFile(dataset: Dataset): string {
  const lines = [
    '#!mainFile "../main.opy"',
    "#",
    "# GENERATED FILE - DO NOT EDIT.",
    `# Source dataset: ${datasetPath}`,
    `# Snapshot: ${dataset.snapshot.id}`,
    `# Effective date: ${dataset.snapshot.effectiveDate}`,
    `# Reference ruleset: ${dataset.generation.referenceRuleset}`,
    `# Source: ${dataset.snapshot.source.identifier}`,
    `# Verification status: ${dataset.snapshot.verificationStatus}`,
    "",
  ];
  let lastHero = "";
  for (const reference of dataset.references) {
    if (reference.hero !== lastHero) {
      if (lastHero) lines.push("");
      lines.push(`# ${displayHero(reference.hero)}`);
      lastHero = reference.hero;
    }
    lines.push(`#!define ${reference.constant} ${renderValue(reference)}`);
  }
  return `${lines.join("\n")}\n`;
}

async function validateProjectCoverage(dataset: Dataset): Promise<void> {
  const audit = JSON.parse(await fs.readFile(resolveRepo(auditPath), "utf8")) as Audit;
  const expected = new Set<string>();
  for (const item of audit.duplicateBaselineFacts) {
    if (item.referenceActive && item.consumers.length > 0 && item.canonicalReference) expected.add(item.canonicalReference);
  }
  for (const item of audit.directOw2Consumers) {
    if (item.canonicalReference) expected.add(item.canonicalReference);
  }
  const actual = new Set(dataset.references.map((reference) => reference.constant));
  const missing = [...expected].filter((constant) => !actual.has(constant)).sort(compareStrings);
  const extra = [...actual].filter((constant) => !expected.has(constant)).sort(compareStrings);
  if (missing.length > 0 || extra.length > 0) {
    throw new Error(`reference snapshot does not match audited project coverage; missing=${missing.join(",") || "none"}; extra=${extra.join(",") || "none"}`);
  }
}

async function main(): Promise<void> {
  const args = parseArgs(process.argv.slice(2));
  const datasetFile = resolveRepo(datasetPath);
  const dataset = JSON.parse(await fs.readFile(datasetFile, "utf8")) as Dataset;
  validateDataset(dataset);
  await validateProjectCoverage(dataset);
  const generated = renderGeneratedFile(dataset);
  const outputFile = resolveRepo(dataset.generation.output);
  if (args.write) {
    await writeText(outputFile, generated);
    console.log(`Generated ${dataset.generation.output} from ${datasetPath} (${dataset.references.length} references)`);
    return;
  }
  const existing = await readText(outputFile);
  if (existing !== generated) throw new Error(`${dataset.generation.output} is out of date; run with --write`);
  console.log(`Generated reference output is current (${dataset.references.length} references)`);
}

main().catch((error: Error) => {
  console.error(error.message);
  process.exit(1);
});
