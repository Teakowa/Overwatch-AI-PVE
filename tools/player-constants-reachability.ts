#!/usr/bin/env -S node --import tsx

import fs from "node:fs/promises";
import path from "node:path";
import { repoRoot, resolveRepo } from "./lib/runtime.js";

const DEFINE_RE = /^#!define\s+([A-Z][A-Z0-9_]*)\s+(.*)$/;
const TOKEN_RE = /\b[A-Z][A-Z0-9_]*\b/g;
const COMMENT_RE = /^\s*#/;

type Args = {
  constantsFile: string;
  srcRoot: string;
  prefixes: string[];
  globalCleanup: boolean;
  apply: boolean;
  json: boolean;
  reportFile: string | null;
};

function parseArgs(argv: string[]): Args {
  const args: Args = {
    constantsFile: "src/constants/player_constants.opy",
    srcRoot: "src",
    prefixes: [],
    globalCleanup: false,
    apply: false,
    json: false,
    reportFile: null,
  };

  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index]!;
    switch (arg) {
      case "--constants-file":
        args.constantsFile = argv[++index] ?? "";
        break;
      case "--src-root":
        args.srcRoot = argv[++index] ?? "";
        break;
      case "--prefix":
        args.prefixes.push(argv[++index] ?? "");
        break;
      case "--global-cleanup":
        args.globalCleanup = true;
        break;
      case "--apply":
        args.apply = true;
        break;
      case "--json":
        args.json = true;
        break;
      case "--report-file":
        args.reportFile = argv[++index] ?? "";
        break;
      case "-h":
      case "--help":
        printHelp();
        process.exit(0);
      default:
        throw new Error(`Unknown argument: ${arg}`);
    }
  }

  if (args.apply && !args.globalCleanup && args.prefixes.length === 0) {
    throw new Error("refuse to apply without scope: use --prefix <HERO_> or --global-cleanup");
  }

  return args;
}

function printHelp(): void {
  console.log("Usage: tools/player-constants-reachability.ts [options]");
  console.log("  --constants-file PATH");
  console.log("  --src-root PATH");
  console.log("  --prefix HERO_");
  console.log("  --global-cleanup");
  console.log("  --apply");
  console.log("  --json");
  console.log("  --report-file PATH");
}

async function parseDefines(constantsFile: string): Promise<{
  order: string[];
  expr: Map<string, string>;
  lines: string[];
}> {
  const lines = (await fs.readFile(constantsFile, "utf8")).split(/\r?\n/);
  const order: string[] = [];
  const expr = new Map<string, string>();

  for (const line of lines) {
    const match = line.match(DEFINE_RE);
    if (!match) {
      continue;
    }
    order.push(match[1]!);
    expr.set(match[1]!, match[2]!);
  }

  return { order, expr, lines };
}

function buildDependencies(expr: Map<string, string>, defs: Set<string>): Map<string, Set<string>> {
  const deps = new Map<string, Set<string>>();
  for (const [name, value] of expr.entries()) {
    const next = new Set<string>();
    for (const token of value.match(TOKEN_RE) ?? []) {
      if (defs.has(token) && token !== name) {
        next.add(token);
      }
    }
    deps.set(name, next);
  }
  return deps;
}

async function collectExternalTokens(srcRoot: string, constantsFile: string): Promise<Set<string>> {
  const tokens = new Set<string>();
  async function walk(current: string): Promise<void> {
    const entries = await fs.readdir(current, { withFileTypes: true });
    for (const entry of entries) {
      const fullPath = path.join(current, entry.name);
      if (entry.isDirectory()) {
        await walk(fullPath);
        continue;
      }
      if (!entry.name.endsWith(".opy") || path.resolve(fullPath) === path.resolve(constantsFile)) {
        continue;
      }
      const lines = (await fs.readFile(fullPath, "utf8")).split(/\r?\n/);
      for (const line of lines) {
        if (COMMENT_RE.test(line)) {
          continue;
        }
        for (const token of line.match(TOKEN_RE) ?? []) {
          tokens.add(token);
        }
      }
    }
  }
  await walk(srcRoot);
  return tokens;
}

function reachableConstants(
  defs: Set<string>,
  deps: Map<string, Set<string>>,
  externalTokens: Set<string>,
): Set<string> {
  const roots = [...defs].filter((name) => externalTokens.has(name));
  const keep = new Set<string>();
  const stack = [...roots];

  while (stack.length > 0) {
    const current = stack.pop()!;
    if (keep.has(current)) {
      continue;
    }
    keep.add(current);
    for (const dep of deps.get(current) ?? []) {
      if (!keep.has(dep)) {
        stack.push(dep);
      }
    }
  }

  return keep;
}

function filterCandidates(unused: string[], prefixes: string[], globalCleanup: boolean): string[] {
  if (globalCleanup) {
    return unused;
  }
  if (prefixes.length === 0) {
    return [];
  }
  return unused.filter((name) => prefixes.some((prefix) => name.startsWith(prefix)));
}

async function applyDelete(lines: string[], deleteNames: Set<string>, constantsFile: string): Promise<void> {
  const kept = lines.filter((line) => {
    const match = line.match(DEFINE_RE);
    return !match || !deleteNames.has(match[1]!);
  });
  await fs.writeFile(constantsFile, `${kept.join("\n")}\n`, "utf8");
}

async function main(): Promise<void> {
  const args = parseArgs(process.argv.slice(2));
  const constantsFile = resolveRepo(args.constantsFile);
  const srcRoot = resolveRepo(args.srcRoot);

  const { order, expr, lines } = await parseDefines(constantsFile);
  const defs = new Set(order);
  const deps = buildDependencies(expr, defs);
  const externalTokens = await collectExternalTokens(srcRoot, constantsFile);
  const keep = reachableConstants(defs, deps, externalTokens);

  const unused = order.filter((name) => !keep.has(name));
  const candidates = filterCandidates(unused, args.prefixes, args.globalCleanup);

  const payload = {
    defined: order.length,
    external_roots: [...defs].filter((name) => externalTokens.has(name)).length,
    reachable: keep.size,
    unused_total: unused.length,
    candidate_unused_count: candidates.length,
    candidate_unused: candidates,
    constants_file: path.relative(repoRoot, constantsFile),
    scope: {
      prefix: args.prefixes,
      global_cleanup: args.globalCleanup,
      apply: args.apply,
    },
  };

  if (args.json) {
    console.log(JSON.stringify(payload, null, 2));
  } else {
    console.log(`defined=${payload.defined}`);
    console.log(`external_roots=${payload.external_roots}`);
    console.log(`reachable=${payload.reachable}`);
    console.log(`unused_total=${payload.unused_total}`);
    console.log(`candidate_unused_count=${payload.candidate_unused_count}`);
    for (const name of candidates) {
      console.log(name);
    }
  }

  if (args.reportFile) {
    await fs.writeFile(resolveRepo(args.reportFile), `${JSON.stringify(payload, null, 2)}\n`, "utf8");
  }

  if (args.apply && candidates.length > 0) {
    await applyDelete(lines, new Set(candidates), constantsFile);
    console.log(`applied_delete_count=${candidates.length}`);
  } else if (args.apply) {
    console.log("applied_delete_count=0");
  }
}

main().catch((error: Error) => {
  console.error(error.message);
  process.exit(1);
});
