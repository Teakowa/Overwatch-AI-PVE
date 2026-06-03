#!/usr/bin/env -S node --import tsx

import fs from "node:fs/promises";
import {
  DEFAULT_HEROES_URL,
  DEFAULT_USER_AGENT,
  extractHeroNames,
  fetchText,
  loadHeroAllowlist,
  writeJson,
} from "../lib/fandom.js";

type Args = {
  url: string;
  htmlFile: string | null;
  allowlist: string | null;
  timeout: number;
  userAgent: string;
  output: string | null;
  pretty: boolean;
};

function parseArgs(argv: string[]): Args {
  const args: Args = {
    url: DEFAULT_HEROES_URL,
    htmlFile: null,
    allowlist: null,
    timeout: 20,
    userAgent: DEFAULT_USER_AGENT,
    output: null,
    pretty: false,
  };
  for (let index = 0; index < argv.length; index += 1) {
    const arg = argv[index]!;
    switch (arg) {
      case "--url":
        args.url = argv[++index] ?? "";
        break;
      case "--html-file":
        args.htmlFile = argv[++index] ?? "";
        break;
      case "--allowlist":
        args.allowlist = argv[++index] ?? "";
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
        console.log("Usage: tools/fandom/fetch-heroes.ts [--html-file PATH] [--allowlist PATH] [--output PATH] [--pretty]");
        process.exit(0);
      default:
        throw new Error(`Unknown argument: ${arg}`);
    }
  }
  return args;
}

async function main(): Promise<void> {
  const args = parseArgs(process.argv.slice(2));
  const html = args.htmlFile ? await fs.readFile(args.htmlFile, "utf8") : await fetchText(args.url, args.timeout, args.userAgent);
  let heroes = extractHeroNames(html);
  if (args.allowlist) {
    const allowlist = await loadHeroAllowlist(args.allowlist);
    heroes = heroes.filter((hero) => allowlist.has(hero));
  }
  await writeJson(
    args.output,
    {
      source: args.htmlFile ?? args.url,
      count: heroes.length,
      heroes,
    },
    args.pretty,
  );
}

main().catch((error: Error) => {
  console.error(error.message);
  process.exit(1);
});
