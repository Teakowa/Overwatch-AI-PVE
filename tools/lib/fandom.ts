import fs from "node:fs/promises";
import path from "node:path";

export const DEFAULT_URL_TEMPLATE = "https://overwatch.fandom.com/wiki/{heroName}";
export const DEFAULT_HEROES_URL = "https://overwatch.fandom.com/wiki/Heroes";
export const DEFAULT_USER_AGENT = "Mozilla/5.0 (compatible; ow-fandom-hero-data/1.0)";

const KNOWN_NAMESPACES = new Set([
  "Category",
  "File",
  "Template",
  "Special",
  "Help",
  "User",
  "Talk",
  "Forum",
  "Blog",
  "Module",
  "MediaWiki",
]);

const EXCLUDED_EXACT = new Set([
  "Heroes",
  "Hero",
  "Overwatch",
  "Overwatch 2",
  "Damage",
  "Tank",
  "Support",
  "Overwatch Wiki",
  "Patch",
  "Maps",
  "Modes",
  "Story",
  "Lore",
]);

const NAME_PATTERN = /^[\w .':+\-]+$/u;

export async function fetchText(url: string, timeoutSeconds: number, userAgent: string): Promise<string> {
  const response = await fetch(url, {
    headers: { "User-Agent": userAgent },
    signal: AbortSignal.timeout(timeoutSeconds * 1000),
  });
  if (!response.ok) {
    throw new Error(`Request failed: ${response.status} ${response.statusText}`);
  }
  return response.text();
}

export function cleanHeroName(raw: string): string | null {
  let name = decodeURIComponent(raw).replaceAll("_", " ").trim();
  if (!name) {
    return null;
  }
  if (name.includes("#")) {
    name = name.split("#", 1)[0]!.trim();
  }
  if (name.includes("?")) {
    name = name.split("?", 1)[0]!.trim();
  }
  if (!name || name.endsWith("(disambiguation)")) {
    return null;
  }
  const namespace = name.split(":", 1)[0]!;
  if (KNOWN_NAMESPACES.has(namespace) || name.includes("/")) {
    return null;
  }
  if (EXCLUDED_EXACT.has(name)) {
    return null;
  }
  if (name.startsWith("List of") || name.startsWith("List Of")) {
    return null;
  }
  if (!NAME_PATTERN.test(name)) {
    return null;
  }
  return name;
}

export function extractHeroNames(pageHtml: string): string[] {
  const names = new Set<string>();
  const hrefRegex = /<a\b[^>]*\bhref="([^"]+)"/g;
  for (const match of pageHtml.matchAll(hrefRegex)) {
    const href = match[1]!;
    let url: URL;
    try {
      url = new URL(href, DEFAULT_HEROES_URL);
    } catch {
      continue;
    }
    if (!url.pathname.includes("/wiki/")) {
      continue;
    }
    const slug = url.pathname.split("/wiki/")[1];
    if (!slug) {
      continue;
    }
    const hero = cleanHeroName(slug);
    if (hero) {
      names.add(hero);
    }
  }
  return [...names].sort((a, b) => a.localeCompare(b, undefined, { sensitivity: "base" }));
}

export function buildHeroUrl(heroName: string, template = DEFAULT_URL_TEMPLATE): string {
  const slug = encodeURIComponent(heroName.trim().replaceAll(" ", "_"))
    .replaceAll("%3A", ":")
    .replaceAll("%28", "(")
    .replaceAll("%29", ")")
    .replaceAll("%27", "'")
    .replaceAll("%21", "!")
    .replaceAll("%2D", "-")
    .replaceAll("%2E", ".")
    .replaceAll("%5F", "_")
    .replaceAll("%7E", "~");
  return template
    .replaceAll("{heroName}", slug)
    .replaceAll("{hero_name}", slug)
    .replaceAll("{hero}", slug);
}

export function normalizeSpaces(value: string): string {
  return value.replace(/\s+/g, " ").trim();
}

export function parseHeroPage(html: string, heroHint?: string): {
  hero: string | null;
  title: string;
  summary: string | null;
  infobox: Record<string, { label: string; value: string }>;
  infobox_fields: Array<{ key: string; label: string; value: string }>;
} {
  const titleMatch = html.match(/<h1\b[^>]*class="[^"]*page-header__title[^"]*"[^>]*>([\s\S]*?)<\/h1>/i);
  const title = normalizeSpaces(stripTags(titleMatch?.[1] ?? ""));

  const parserOutputMatch = html.match(
    /<(?:div|section)\b[^>]*class="[^"]*mw-parser-output[^"]*"[^>]*>([\s\S]*?)<\/(?:div|section)>/i,
  );
  const parserOutput = parserOutputMatch?.[1] ?? "";
  const paragraphMatch = parserOutput.match(/<p\b[^>]*>([\s\S]*?)<\/p>/i);
  const summaryText = normalizeSpaces(stripTags(paragraphMatch?.[1] ?? ""));
  const summary = summaryText || null;

  const fieldRegex =
    /<[^>]*data-source="([^"]+)"[^>]*>([\s\S]*?)<\/(?:div|section|aside|li|td|tr)>/gi;
  const fields: Array<{ key: string; label: string; value: string }> = [];
  const infobox: Record<string, { label: string; value: string }> = {};
  for (const match of html.matchAll(fieldRegex)) {
    const key = normalizeSpaces(match[1]!).replaceAll(" ", "_");
    if (!key || infobox[key]) {
      continue;
    }
    const block = match[2]!;
    const labelMatch = block.match(/class="[^"]*pi-data-label[^"]*"[^>]*>([\s\S]*?)<\/[^>]+>/i);
    const valueMatch = block.match(/class="[^"]*pi-data-value[^"]*"[^>]*>([\s\S]*?)<\/[^>]+>/i);
    const label = normalizeSpaces(stripTags(labelMatch?.[1] ?? "")) || key.replaceAll("_", " ");
    const value = normalizeSpaces(stripTags(valueMatch?.[1] ?? ""));
    if (!label && !value) {
      continue;
    }
    const item = { key, label, value };
    fields.push(item);
    infobox[key] = { label, value };
  }

  return {
    hero: heroHint ?? (title || null),
    title,
    summary,
    infobox,
    infobox_fields: fields,
  };
}

function stripTags(value: string): string {
  return value
    .replace(/<script[\s\S]*?<\/script>/gi, " ")
    .replace(/<style[\s\S]*?<\/style>/gi, " ")
    .replace(/<[^>]+>/g, " ")
    .replace(/&nbsp;/gi, " ")
    .replace(/&amp;/gi, "&")
    .replace(/&quot;/gi, "\"")
    .replace(/&#39;/gi, "'");
}

export async function writeJson(output: string | null, payload: unknown, pretty: boolean): Promise<void> {
  const content = JSON.stringify(payload, null, pretty ? 2 : undefined);
  if (!output) {
    process.stdout.write(`${content}\n`);
    return;
  }
  await fs.mkdir(path.dirname(output), { recursive: true });
  await fs.writeFile(output, `${content}\n`, "utf8");
}

export async function loadHeroAllowlist(filePath: string): Promise<Set<string>> {
  const allowed = new Set<string>();
  const lines = (await fs.readFile(filePath, "utf8")).split(/\r?\n/);
  for (const rawLine of lines) {
    const line = rawLine.trim();
    if (!line || line.startsWith("#")) {
      continue;
    }
    allowed.add(line.replaceAll("_", " ").trim());
  }
  return allowed;
}

export function normalizeHeroName(value: string): string {
  return value.replaceAll("_", " ").trim();
}
