#!/usr/bin/env -S node --import tsx

import fs from "node:fs/promises";
import path from "node:path";
import {
  buildHeroUrl,
  DEFAULT_URL_TEMPLATE,
  DEFAULT_USER_AGENT,
  fetchText,
  normalizeHeroName,
  parseHeroPage,
  writeJson,
} from "../lib/fandom.js";

type Args = {
  heroesFile: string;
  htmlDir: string | null;
  urlTemplate: string;
  timeout: number;
  userAgent: string;
  delay: number;
  max: number | null;
  output: string | null;
  pretty: boolean;
  failOnError: boolean;
};

function parseArgs(argv: string[]): Args {
  const args: Args = {
    heroesFile: "",
    htmlDir: null,
    urlTemplate: DEFAULT_URL_TEMPLATE,
    timeout: 20,
    userAgent: DEFAULT_USER_AGENT,
    delay: 0.3,
    max: null,
    output: null,
    pretty: false,
    failOnError: false,
  };
  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index]!;
    switch (arg) {
      case "--heroes-file":
        args.heroesFile = argv[++index] ?? "";
        break;
      case "--html-dir":
        args.htmlDir = argv[++index] ?? "";
        break;
      case "--url-template":
        args.urlTemplate = argv[++index] ?? "";
        break;
      case "--timeout":
        args.timeout = Number(argv[++index] ?? "20");
        break;
      case "--user-agent":
        args.userAgent = argv[++index] ?? "";
        break;
      case "--delay":
        args.delay = Number(argv[++index] ?? "0.3");
        break;
      case "--max":
        args.max = Number(argv[++index] ?? "0");
        break;
      case "--output":
        args.output = argv[++index] ?? "";
        break;
      case "--pretty":
        args.pretty = true;
        break;
      case "--fail-on-error":
        args.failOnError = true;
        break;
      case "-h":
      case "--help":
        console.log("Usage: tools/fandom/fetch-all-hero-details.ts --heroes-file PATH [--html-dir PATH] [--output PATH]");
        process.exit(0);
      default:
        throw new Error(`Unknown argument: ${arg}`);
    }
  }
  if (!args.heroesFile) {
    throw new Error("--heroes-file is required");
  }
  return args;
}

async function loadHeroes(filePath: string): Promise<string[]> {
  const raw = await fs.readFile(filePath, "utf8");
  const suffix = path.extname(filePath).toLowerCase();
  const heroes: string[] = [];

  if (suffix === ".json") {
    const data = JSON.parse(raw) as unknown;
    const sourceHeroes =
      Array.isArray(data) ? data : typeof data === "object" && data && Array.isArray((data as { heroes?: unknown }).heroes)
        ? (data as { heroes: unknown[] }).heroes
        : null;
    if (!sourceHeroes) {
      throw new Error("JSON heroes file must be a list or an object with a 'heroes' list");
    }
    for (const item of sourceHeroes) {
      if (typeof item === "string") {
        const hero = normalizeHeroName(item);
        if (hero) {
          heroes.push(hero);
        }
      } else if (typeof item === "object" && item && typeof (item as { hero?: unknown }).hero === "string") {
        const hero = normalizeHeroName((item as { hero: string }).hero);
        if (hero) {
          heroes.push(hero);
        }
      }
    }
  } else {
    for (const rawLine of raw.split(/\r?\n/)) {
      const line = rawLine.trim();
      if (!line || line.startsWith("#")) {
        continue;
      }
      heroes.push(normalizeHeroName(line));
    }
  }

  const seen = new Set<string>();
  return heroes.filter((hero) => {
    if (!hero || seen.has(hero)) {
      return false;
    }
    seen.add(hero);
    return true;
  });
}

async function resolveHtmlFile(htmlDir: string, hero: string): Promise<string> {
  const slug = hero.replaceAll(" ", "_");
  const candidates = [path.join(htmlDir, `${slug}.html`), path.join(htmlDir, `${encodeURIComponent(slug)}.html`)];
  for (const candidate of candidates) {
    try {
      await fs.access(candidate);
      return candidate;
    } catch {
      // ignore
    }
  }
  throw new Error(`No local HTML file found for hero '${hero}' in ${htmlDir}`);
}

async function sleep(seconds: number): Promise<void> {
  await new Promise((resolve) => setTimeout(resolve, seconds * 1000));
}

async function main(): Promise<void> {
  const args = parseArgs(process.argv.slice(2));
  let heroes = await loadHeroes(args.heroesFile);
  if (args.max !== null && args.max >= 0) {
    heroes = heroes.slice(0, args.max);
  }

  const results: unknown[] = [];
  const failures: Array<{ hero: string; error: string }> = [];

  for (let index = 0; index < heroes.length; index += 1) {
    const hero = heroes[index]!;
    try {
      let html: string;
      let sourceUrl: string;
      if (args.htmlDir) {
        const htmlPath = await resolveHtmlFile(args.htmlDir, hero);
        html = await fs.readFile(htmlPath, "utf8");
        sourceUrl = htmlPath;
      } else {
        sourceUrl = buildHeroUrl(hero, args.urlTemplate);
        html = await fetchText(sourceUrl, args.timeout, args.userAgent);
      }
      results.push({ ...parseHeroPage(html, hero), url: sourceUrl });
    } catch (error) {
      failures.push({ hero, error: (error as Error).message });
    }

    if (index < heroes.length - 1 && args.delay > 0) {
      await sleep(args.delay);
    }
  }

  await writeJson(
    args.output,
    {
      source: args.heroesFile,
      count: results.length,
      failed_count: failures.length,
      heroes: results,
      failures,
    },
    args.pretty,
  );

  if (args.failOnError && failures.length > 0) {
    process.exit(1);
  }
}

main().catch((error: Error) => {
  console.error(error.message);
  process.exit(1);
});
