#!/usr/bin/env -S node --import tsx

import fs from "node:fs/promises";
import process from "node:process";
import { listOpyFiles, readText, relRepo, runCommand, resolveRepo } from "./lib/runtime.js";

type Dataset = {
  references: Array<{ constant: string }>;
};

type Audit = {
  summary: {
    duplicateBaselineFacts: number;
    missingProjectConsumedReferences: number;
  };
  baselineFields: Array<{
    id: string;
    main: { isNumericLiteral: boolean };
    aram: Array<{ isNumericLiteral: boolean }>;
  }>;
};

const generatedReferencePath = resolveRepo("src/constants/ow2_hero_defaults.opy");

function escapeRegex(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

async function readJson<T>(path: string): Promise<T> {
  return JSON.parse(await fs.readFile(path, "utf8")) as T;
}

async function main(): Promise<void> {
  const dataset = await readJson<Dataset>(resolveRepo("data/ow2/reference-snapshot.json"));
  const audit = await readJson<Audit>(resolveRepo("data/ow2/hero-balance-audit.json"));
  const canonicalReferences = new Set(dataset.references.map((reference) => reference.constant));
  const deprecatedAliases = [...canonicalReferences].map((reference) => reference.slice("OW2_".length));
  const duplicateDefinitions: string[] = [];
  const deprecatedUses: string[] = [];

  for (const filePath of listOpyFiles(resolveRepo("src"))) {
    if (filePath === generatedReferencePath) continue;
    const lines = (await readText(filePath)).split(/\r?\n/);
    for (let index = 0; index < lines.length; index += 1) {
      const line = lines[index]!;
      const definition = line.match(/^#!define\s+(OW2_[A-Z0-9_]+)\b/);
      if (definition && canonicalReferences.has(definition[1]!)) {
        duplicateDefinitions.push(`${relRepo(filePath)}:${index + 1}:${definition[1]}`);
      }
      for (const alias of deprecatedAliases) {
        if (new RegExp(`\\b${escapeRegex(alias)}\\b`).test(line)) {
          deprecatedUses.push(`${relRepo(filePath)}:${index + 1}:${alias}`);
        }
      }
    }
  }

  const baselineLiteralFields = audit.baselineFields
    .filter((field) => field.main.isNumericLiteral || field.aram.some((entry) => entry.isNumericLiteral))
    .map((field) => field.id);
  const failures: string[] = [];
  if (duplicateDefinitions.length > 0) failures.push(`duplicate canonical definitions: ${duplicateDefinitions.join(", ")}`);
  if (deprecatedUses.length > 0) failures.push(`deprecated baseline aliases: ${deprecatedUses.join(", ")}`);
  if (audit.summary.duplicateBaselineFacts !== 0) {
    failures.push(`audit still reports ${audit.summary.duplicateBaselineFacts} duplicate baseline facts`);
  }
  if (audit.summary.missingProjectConsumedReferences !== 0) {
    failures.push(`audit still reports ${audit.summary.missingProjectConsumedReferences} missing project references`);
  }
  if (baselineLiteralFields.length > 0) {
    failures.push(`baseline-managed fields reverted to numeric literals: ${baselineLiteralFields.join(", ")}`);
  }

  runCommand("pnpm", ["run", "tool:generate-ow2-reference", "--", "--check"]);
  if (failures.length > 0) throw new Error(failures.join("\n"));

  console.log(`Hero balance architecture is current: ${canonicalReferences.size} canonical references, ${audit.baselineFields.length} baseline-managed fields checked`);
}

main().catch((error: Error) => {
  console.error(error.message);
  process.exit(1);
});
