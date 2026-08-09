#!/usr/bin/env -S node --import tsx

import path from "node:path";
import process from "node:process";
import { readText, relRepo, resolveRepo, writeText } from "./lib/runtime.js";

type Ruleset = "5v5" | "6v6" | "shared" | "unknown";
type Confidence = "high" | "medium" | "low";
type VerificationStatus = "verified" | "cross_checked" | "provisional" | "unverified";
type SourceType = "official_patch_notes" | "repository_import" | "third_party_structured_source" | "manual_review";

type SnapshotReference = {
  constant: string;
  hero: string;
  field: string;
  value?: number;
  expression?: string;
  unit: string;
  ruleset: Ruleset;
};

type Dataset = {
  schemaVersion: number;
  snapshot: {
    id: string;
    effectiveDate: string;
    lastVerified: string | null;
    ruleset: Ruleset;
    verificationStatus: string;
  };
  references: SnapshotReference[];
};

type Source = {
  type: SourceType;
  identifier: string;
  url: string;
  retrievedAt?: string;
};

type ChangeCandidate = {
  id: string;
  hero: string;
  field: string;
  proposedValue: number;
  unit: string;
  ruleset: Ruleset;
  publishedDate: string;
  effectiveDate: string;
  source: Source;
  confidence: Confidence;
  verificationStatus: VerificationStatus;
  note?: string;
};

type ChangeFeed = {
  schemaVersion: number;
  snapshotId: string;
  lastChecked: string;
  sourcePolicy: {
    preferred: SourceType[];
    discovery: SourceType[];
    acceptance: "manual";
  };
  changes: ChangeCandidate[];
};

type AuditConsumer = {
  file: string;
  line: number;
  category?: string;
  value?: string;
};

type AuditBaselineField = {
  id: string;
  hero: string;
  field: string;
  team: string;
  category: string;
  canonicalReference: string | null;
  main: AuditConsumer & {
    mode: "main";
    hero: string;
    field: string;
    team: string;
    category: string;
  };
  aram: Array<AuditConsumer & {
    mode: "aram";
    hero: string;
    field: string;
    team: string;
    category: string;
  }>;
};

type Audit = {
  baselineFields: AuditBaselineField[];
  directOw2Consumers: Array<{
    canonicalReference: string;
    consumers: Array<{ file: string; line: number }>;
  }>;
};

type CandidateContext = {
  id: string;
  hero: string;
  field: string;
  proposedValue: number;
  unit: string;
  candidateRuleset: Ruleset;
  publishedDate: string;
  effectiveDate: string;
  source: Source;
  confidence: Confidence;
  verificationStatus: VerificationStatus;
  note?: string;
};

type ImpactField = {
  id: string;
  mode: "main" | "aram";
  team: string;
  hero: string;
  field: string;
  category: string;
  source: {
    file: string;
    line: number;
  };
  expression: string;
};

type Impact = {
  absoluteTargetConsumers: ImpactField[];
  relativeModifierConsumers: ImpactField[];
  runtimeOrOtherConsumers: ImpactField[];
  directReferenceConsumers: Array<{ file: string; line: number }>;
  guidance: string;
};

type Args = {
  input: string;
  report: string | null;
  since: string | null;
};

const allowedRulesets = new Set<Ruleset>(["5v5", "6v6", "shared", "unknown"]);
const allowedSourceTypes = new Set<SourceType>(["official_patch_notes", "repository_import", "third_party_structured_source", "manual_review"]);
const allowedConfidences = new Set<Confidence>(["high", "medium", "low"]);
const allowedVerificationStatuses = new Set<VerificationStatus>(["verified", "cross_checked", "provisional", "unverified"]);
const datePattern = /^\d{4}-\d{2}-\d{2}$/;

function parseArgs(argv: string[]): Args {
  const args: Args = {
    input: "data/ow2/change-feed.json",
    report: null,
    since: null,
  };
  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index]!;
    if (arg === "--") continue;
    if (arg === "--input" || arg === "--report" || arg === "--since") {
      const value = argv[index + 1];
      if (!value || value === "--") throw new Error(`${arg} requires a value`);
      index += 1;
      if (arg === "--input") args.input = value;
      else if (arg === "--report") args.report = value;
      else args.since = value;
      continue;
    }
    if (arg === "-h" || arg === "--help") {
      console.log("Usage: tools/detect-ow2-reference-changes.ts [--input PATH] [--since YYYY-MM-DD] [--report PATH]");
      process.exit(0);
    }
    throw new Error(`Unknown argument: ${arg}`);
  }
  return args;
}

function assertString(value: unknown, label: string): asserts value is string {
  if (typeof value !== "string" || value.trim().length === 0) throw new Error(`${label} must be a non-empty string`);
}

function assertDate(value: unknown, label: string): asserts value is string {
  assertString(value, label);
  if (!datePattern.test(value)) throw new Error(`${label} must use YYYY-MM-DD: ${value}`);
  const parsed = new Date(`${value}T00:00:00Z`);
  if (Number.isNaN(parsed.getTime()) || parsed.toISOString().slice(0, 10) !== value) throw new Error(`${label} is not a valid calendar date: ${value}`);
}

function assertEnum<T extends string>(value: unknown, allowed: Set<T>, label: string): asserts value is T {
  if (typeof value !== "string" || !allowed.has(value as T)) throw new Error(`${label} has unsupported value: ${String(value)}`);
}

function validateDataset(dataset: Dataset): void {
  if (dataset.schemaVersion !== 1) throw new Error("unsupported reference snapshot schemaVersion");
  assertString(dataset.snapshot?.id, "snapshot.id");
  assertString(dataset.snapshot?.effectiveDate, "snapshot.effectiveDate");
  assertDate(dataset.snapshot.effectiveDate, "snapshot.effectiveDate");
  assertEnum(dataset.snapshot.ruleset, allowedRulesets, "snapshot.ruleset");
  if (!Array.isArray(dataset.references) || dataset.references.length === 0) throw new Error("reference snapshot has no references");
  const keys = new Set<string>();
  for (const reference of dataset.references) {
    assertString(reference.constant, "reference.constant");
    assertString(reference.hero, `reference ${reference.constant}.hero`);
    assertString(reference.field, `reference ${reference.constant}.field`);
    assertString(reference.unit, `reference ${reference.constant}.unit`);
    assertEnum(reference.ruleset, allowedRulesets, `reference ${reference.constant}.ruleset`);
    const key = `${reference.hero}.${reference.field}.${reference.ruleset}`;
    if (keys.has(key)) throw new Error(`duplicate dataset reference: ${key}`);
    keys.add(key);
    const hasValue = typeof reference.value === "number" && Number.isFinite(reference.value);
    const hasExpression = typeof reference.expression === "string" && reference.expression.trim().length > 0;
    if (hasValue === hasExpression) throw new Error(`${reference.constant} must have exactly one numeric value or expression`);
  }
}

function validateSource(source: Source, label: string): void {
  if (!source || typeof source !== "object") throw new Error(`${label} must be an object`);
  assertEnum(source.type, allowedSourceTypes, `${label}.type`);
  assertString(source.identifier, `${label}.identifier`);
  assertString(source.url, `${label}.url`);
  if (!/^https:\/\//.test(source.url)) throw new Error(`${label}.url must use https://`);
  if (source.retrievedAt !== undefined) assertDate(source.retrievedAt, `${label}.retrievedAt`);
}

function validateCandidate(candidate: ChangeCandidate, index: number): void {
  const label = `changes[${index}]`;
  assertString(candidate.id, `${label}.id`);
  if (!/^[a-z0-9][a-z0-9._-]*$/.test(candidate.id)) throw new Error(`${label}.id must be lowercase kebab-case`);
  assertString(candidate.hero, `${label}.hero`);
  assertString(candidate.field, `${label}.field`);
  if (!Number.isFinite(candidate.proposedValue)) throw new Error(`${label}.proposedValue must be a finite number`);
  assertString(candidate.unit, `${label}.unit`);
  assertEnum(candidate.ruleset, allowedRulesets, `${label}.ruleset`);
  assertDate(candidate.publishedDate, `${label}.publishedDate`);
  assertDate(candidate.effectiveDate, `${label}.effectiveDate`);
  validateSource(candidate.source, `${label}.source`);
  assertEnum(candidate.confidence, allowedConfidences, `${label}.confidence`);
  assertEnum(candidate.verificationStatus, allowedVerificationStatuses, `${label}.verificationStatus`);
  if (candidate.note !== undefined) assertString(candidate.note, `${label}.note`);
}

function validateFeed(feed: ChangeFeed, dataset: Dataset): void {
  if (feed.schemaVersion !== 1) throw new Error("unsupported change feed schemaVersion");
  assertString(feed.snapshotId, "change feed snapshotId");
  if (feed.snapshotId !== dataset.snapshot.id) throw new Error(`change feed snapshotId ${feed.snapshotId} does not match dataset ${dataset.snapshot.id}`);
  assertDate(feed.lastChecked, "change feed lastChecked");
  if (!feed.sourcePolicy || typeof feed.sourcePolicy !== "object") throw new Error("change feed sourcePolicy is required");
  if (!Array.isArray(feed.sourcePolicy.preferred) || !Array.isArray(feed.sourcePolicy.discovery)) throw new Error("sourcePolicy.preferred and sourcePolicy.discovery must be arrays");
  for (const sourceType of [...feed.sourcePolicy.preferred, ...feed.sourcePolicy.discovery]) assertEnum(sourceType, allowedSourceTypes, "sourcePolicy source type");
  if (feed.sourcePolicy.acceptance !== "manual") throw new Error("sourcePolicy.acceptance must be manual");
  if (!Array.isArray(feed.changes)) throw new Error("change feed changes must be an array");
  const ids = new Set<string>();
  for (let index = 0; index < feed.changes.length; index += 1) {
    const candidate = feed.changes[index]!;
    validateCandidate(candidate, index);
    if (ids.has(candidate.id)) throw new Error(`duplicate change candidate id: ${candidate.id}`);
    ids.add(candidate.id);
  }
}

function readCurrentValue(reference: SnapshotReference): number | string {
  if (typeof reference.value === "number") return reference.value;
  if (typeof reference.expression === "string") return reference.expression;
  throw new Error(`reference ${reference.constant} has no current value`);
}

function resolvePath(value: string): string {
  return path.isAbsolute(value) ? value : resolveRepo(value);
}

function displayPath(value: string): string {
  const relative = relRepo(value);
  return relative.startsWith("..") ? value : relative;
}

function candidateContext(candidate: ChangeCandidate): CandidateContext {
  return {
    id: candidate.id,
    hero: candidate.hero,
    field: candidate.field,
    proposedValue: candidate.proposedValue,
    unit: candidate.unit,
    candidateRuleset: candidate.ruleset,
    publishedDate: candidate.publishedDate,
    effectiveDate: candidate.effectiveDate,
    source: candidate.source,
    confidence: candidate.confidence,
    verificationStatus: candidate.verificationStatus,
    ...(candidate.note ? { note: candidate.note } : {}),
  };
}

function buildImpact(canonicalReference: string, audit: Audit): Impact {
  const absoluteTargetConsumers: ImpactField[] = [];
  const relativeModifierConsumers: ImpactField[] = [];
  const runtimeOrOtherConsumers: ImpactField[] = [];
  const seen = new Set<string>();
  const addConsumer = (field: AuditBaselineField, consumer: AuditConsumer & { mode: "main" | "aram"; hero: string; field: string; team: string; category: string }, mode: "main" | "aram"): void => {
    const key = `${mode}:${consumer.file}:${consumer.line}`;
    if (seen.has(key)) return;
    seen.add(key);
    const item: ImpactField = {
      id: `${field.id}:${mode}:${consumer.file}:${consumer.line}`,
      mode,
      team: consumer.team,
      hero: consumer.hero,
      field: consumer.field,
      category: consumer.category,
      source: { file: consumer.file, line: consumer.line },
      expression: consumer.value ?? "",
    };
    if (consumer.category === "absolute_pve_target") absoluteTargetConsumers.push(item);
    else if (consumer.category === "relative_pve_modifier") relativeModifierConsumers.push(item);
    else runtimeOrOtherConsumers.push(item);
  };

  for (const field of audit.baselineFields) {
    if (field.canonicalReference !== canonicalReference) continue;
    addConsumer(field, field.main, "main");
    for (const aram of field.aram) addConsumer(field, aram, "aram");
  }

  const directReferenceConsumers = audit.directOw2Consumers
    .filter((item) => item.canonicalReference === canonicalReference)
    .flatMap((item) => item.consumers)
    .filter((consumer, index, consumers) => consumers.findIndex((candidate) => candidate.file === consumer.file && candidate.line === consumer.line) === index)
    .sort((left, right) => left.file.localeCompare(right.file) || left.line - right.line);

  return {
    absoluteTargetConsumers,
    relativeModifierConsumers,
    runtimeOrOtherConsumers,
    directReferenceConsumers,
    guidance: "绝对 target 消费者应在接受新 reference 后重新计算 Workshop 百分比，以保持固定的 PvE 有效值；relative modifier 消费者保持配置的相对比例，因此接受新 reference 会改变其有效玩法表现。",
  };
}

function selectReference(candidates: SnapshotReference[], ruleset: Ruleset, configuredRuleset: Ruleset): SnapshotReference | null {
  if (ruleset === configuredRuleset) return candidates.find((reference) => reference.ruleset === configuredRuleset) ?? null;
  if (ruleset === "shared") return candidates.find((reference) => reference.ruleset === "shared") ?? candidates.find((reference) => reference.ruleset === configuredRuleset) ?? null;
  return null;
}

function baseWithStatus(candidate: ChangeCandidate, status: string): Record<string, unknown> {
  return { status, ...candidateContext(candidate) };
}

function analyzeCandidate(candidate: ChangeCandidate, dataset: Dataset, audit: Audit): {
  kind: "delta" | "unchanged" | "untracked" | "ruleset" | "unit" | "review";
  value: Record<string, unknown>;
} {
  const matching = dataset.references.filter((reference) => reference.hero === candidate.hero && reference.field === candidate.field);
  if (matching.length === 0) return { kind: "untracked", value: baseWithStatus(candidate, "untracked_field") };

  const selected = selectReference(matching, candidate.ruleset, dataset.snapshot.ruleset);
  if (!selected) {
    return {
      kind: "ruleset",
      value: {
        ...baseWithStatus(candidate, "ruleset_not_selected"),
        availableReferenceRulesets: [...new Set(matching.map((reference) => reference.ruleset))].sort(),
        selectedSnapshotRuleset: dataset.snapshot.ruleset,
      },
    };
  }

  const currentValue = readCurrentValue(selected);
  if (candidate.unit !== selected.unit) {
    return {
      kind: "unit",
      value: {
        ...baseWithStatus(candidate, "unit_mismatch"),
        referenceConstant: selected.constant,
        oldValue: currentValue,
        referenceUnit: selected.unit,
        selectedRuleset: selected.ruleset,
      },
    };
  }
  if (typeof currentValue !== "number") {
    return {
      kind: "review",
      value: {
        ...baseWithStatus(candidate, "current_reference_expression"),
        referenceConstant: selected.constant,
        oldValue: currentValue,
        selectedRuleset: selected.ruleset,
        impact: buildImpact(selected.constant, audit),
      },
    };
  }
  if (candidate.proposedValue === currentValue) {
    return {
      kind: "unchanged",
      value: {
        ...baseWithStatus(candidate, "unchanged"),
        referenceConstant: selected.constant,
        oldValue: currentValue,
        selectedRuleset: selected.ruleset,
      },
    };
  }
  return {
    kind: "delta",
    value: {
      ...baseWithStatus(candidate, "candidate_delta"),
      referenceConstant: selected.constant,
      oldValue: currentValue,
      proposedValue: candidate.proposedValue,
      delta: candidate.proposedValue - currentValue,
      selectedRuleset: selected.ruleset,
      impact: buildImpact(selected.constant, audit),
    },
  };
}

async function main(): Promise<void> {
  const args = parseArgs(process.argv.slice(2));
  const inputPath = resolvePath(args.input);
  const reportPath = args.report ? resolvePath(args.report) : null;
  const dataset = JSON.parse(await readText(resolveRepo("data/ow2/reference-snapshot.json"))) as Dataset;
  const audit = JSON.parse(await readText(resolveRepo("data/ow2/hero-balance-audit.json"))) as Audit;
  const feed = JSON.parse(await readText(inputPath)) as ChangeFeed;
  validateDataset(dataset);
  validateFeed(feed, dataset);
  const since = args.since ?? feed.lastChecked;
  assertDate(since, "since");
  const relevant = feed.changes.filter((candidate) => candidate.publishedDate > since);
  const unchanged: Record<string, unknown>[] = [];
  const candidateDeltas: Record<string, unknown>[] = [];
  const untrackedChanges: Record<string, unknown>[] = [];
  const rulesetMismatches: Record<string, unknown>[] = [];
  const unitMismatches: Record<string, unknown>[] = [];
  const reviewRequired: Record<string, unknown>[] = [];
  for (const candidate of relevant) {
    const result = analyzeCandidate(candidate, dataset, audit);
    if (result.kind === "delta") candidateDeltas.push(result.value);
    else if (result.kind === "unchanged") unchanged.push(result.value);
    else if (result.kind === "untracked") untrackedChanges.push(result.value);
    else if (result.kind === "ruleset") rulesetMismatches.push(result.value);
    else if (result.kind === "unit") unitMismatches.push(result.value);
    else reviewRequired.push(result.value);
  }

  const report = {
    schemaVersion: 1,
    generatedBy: "tools/detect-ow2-reference-changes.ts",
    input: displayPath(inputPath),
    snapshot: {
      id: dataset.snapshot.id,
      effectiveDate: dataset.snapshot.effectiveDate,
      lastVerified: dataset.snapshot.lastVerified,
      ruleset: dataset.snapshot.ruleset,
      verificationStatus: dataset.snapshot.verificationStatus,
      canonicalSnapshotUpdated: false,
    },
    since,
    feedLastChecked: feed.lastChecked,
    sourcePolicy: feed.sourcePolicy,
    counts: {
      totalCandidates: feed.changes.length,
      candidatesAfterMarker: relevant.length,
      skippedBeforeOrAtMarker: feed.changes.length - relevant.length,
      candidateDeltas: candidateDeltas.length,
      unchanged: unchanged.length,
      untrackedChanges: untrackedChanges.length,
      rulesetMismatches: rulesetMismatches.length,
      unitMismatches: unitMismatches.length,
      reviewRequired: reviewRequired.length,
    },
    candidateDeltas,
    unchanged,
    untrackedChanges,
    rulesetMismatches,
    unitMismatches,
    reviewRequired,
  };

  const hasReviewOutput = candidateDeltas.length > 0 || untrackedChanges.length > 0 || rulesetMismatches.length > 0 || unitMismatches.length > 0 || reviewRequired.length > 0;
  if (reportPath) {
    await writeText(reportPath, `${JSON.stringify(report, null, 2)}\n`);
    console.log(`Wrote ${displayPath(reportPath)} (${candidateDeltas.length} candidate delta(s), ${untrackedChanges.length} untracked change(s))`);
  }
  if (!hasReviewOutput) {
    console.log(`No candidate OW2 changes after ${since} (${unchanged.length} unchanged, ${feed.changes.length - relevant.length} before marker)`);
    return;
  }
  if (!reportPath) console.log(JSON.stringify(report, null, 2));
}

main().catch((error: Error) => {
  console.error(error.message);
  process.exit(1);
});
