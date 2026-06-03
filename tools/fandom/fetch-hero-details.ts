#!/usr/bin/env -S node --import tsx

import fs from "node:fs/promises";
import {
  buildHeroUrl,
  DEFAULT_URL_TEMPLATE,
  DEFAULT_USER_AGENT,
  fetchText,
  parseHeroPage,
  writeJson,
} from "../lib/fandom.js";

type Args = {
  hero: string | null;
  url: string | null;
  urlTemplate: string;
  htmlFile: string | null;
  timeout: number;
  userAgent: string;
  output: string | null;
  pretty: boolean;
};

function parseArgs(argv: string[]): Args {
  const args: Args = {
    hero: null,
    url: null,
    urlTemplate: DEFAULT_URL_TEMPLATE,
    htmlFile: null,
    timeout: 20,
    userAgent: DEFAULT_USER_AGENT,
    output: null,
    pretty: false,
  };
  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index]!;
    switch (arg) {
      case "--hero":
        args.hero = argv[++index] ?? "";
        break;
      case "--url":
        args.url = argv[++index] ?? "";
        break;
      case "--url-template":
        args.urlTemplate = argv[++index] ?? "";
        break;
      case "--html-file":
        args.htmlFile = argv[++index] ?? "";
        break;
      case "--timeout":
        args.timeout = Number(argv[++index] ?? "20");
        break;
      case "--user-agent":
        args.userAgent = argv[++index] ?? "";
        break;
      case "--output":
        args.output = argv[++index] ?? "";
        break;
      case "--pretty":
        args.pretty = true;
        break;
      case "-h":
      case "--help":
        console.log("Usage: tools/fandom/fetch-hero-details.ts [--hero Ana|--url URL|--html-file PATH] [--output PATH]");
        process.exit(0);
      default:
        throw new Error(`Unknown argument: ${arg}`);
    }
  }
  if (!args.htmlFile && !args.url && !args.hero) {
    throw new Error("Provide one of: --hero, --url, or --html-file");
  }
  return args;
}

async function main(): Promise<void> {
  const args = parseArgs(process.argv.slice(2));
  const resolvedUrl = args.htmlFile ? args.url ?? args.htmlFile : args.url ?? buildHeroUrl(args.hero!, args.urlTemplate);
  const html = args.htmlFile ? await fs.readFile(args.htmlFile, "utf8") : await fetchText(resolvedUrl, args.timeout, args.userAgent);
  const parsed = parseHeroPage(html, args.hero ?? undefined);
  await writeJson(args.output, { ...parsed, url: resolvedUrl }, args.pretty);
}

main().catch((error: Error) => {
  console.error(error.message);
  process.exit(1);
});
