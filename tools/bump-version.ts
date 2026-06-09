import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const DEFAULT_VERSION_FILE = path.resolve(__dirname, '../src/version.opy');
const DEFAULT_README_FILE = path.resolve(__dirname, '../README.md');

const VERSION_FILE = process.env.OVERWATCH_AI_PVE_VERSION_FILE
  ? path.resolve(process.cwd(), process.env.OVERWATCH_AI_PVE_VERSION_FILE)
  : DEFAULT_VERSION_FILE;
const README_FILE = process.env.OVERWATCH_AI_PVE_README_FILE
  ? path.resolve(process.cwd(), process.env.OVERWATCH_AI_PVE_README_FILE)
  : DEFAULT_README_FILE;

const VERSION_DEFINE_PATTERN = /^#!define\s+VERSION\s+"([^"]+)"\s*$/gm;
const VERSION_VALUE_PATTERN = /^(\d{2})\.(\d{4})\.(\d+)$/;
const README_BADGE_PATTERN =
  /^!\[\]\(https:\/\/img\.shields\.io\/static\/v1\?label=Version&message=[^&]+&color=blue&style=flat-square\)$/m;

function getNow() {
  if (!process.env.OVERWATCH_AI_PVE_NOW) {
    return new Date();
  }

  const parsed = new Date(process.env.OVERWATCH_AI_PVE_NOW);
  if (Number.isNaN(parsed.getTime())) {
    throw new Error(`Invalid OVERWATCH_AI_PVE_NOW value: ${process.env.OVERWATCH_AI_PVE_NOW}`);
  }

  return parsed;
}

function parseVersion(value: string) {
  const match = value.match(VERSION_VALUE_PATTERN);
  if (!match) {
    throw new Error(`Invalid VERSION format "${value}". Expected YY.MMDD.N in ${VERSION_FILE}`);
  }

  return {
    yy: match[1],
    mmdd: match[2],
    count: Number.parseInt(match[3], 10)
  };
}

function getSingaporeDateParts(now: Date) {
  const formatter = new Intl.DateTimeFormat('en-CA', {
    timeZone: 'Asia/Singapore',
    year: 'numeric',
    month: '2-digit',
    day: '2-digit'
  });
  const parts = formatter.formatToParts(now);
  const year = parts.find((part) => part.type === 'year')?.value;
  const month = parts.find((part) => part.type === 'month')?.value;
  const day = parts.find((part) => part.type === 'day')?.value;

  if (!year || !month || !day) {
    throw new Error('Failed to resolve Asia/Singapore date parts.');
  }

  return {
    yy: year.slice(-2),
    mmdd: `${month}${day}`
  };
}

async function main() {
  const versionSource = await fs.readFile(VERSION_FILE, 'utf8');
  const versionMatches = [...versionSource.matchAll(VERSION_DEFINE_PATTERN)];

  if (versionMatches.length !== 1) {
    throw new Error(`Expected exactly one VERSION definition in ${VERSION_FILE}, found ${versionMatches.length}`);
  }

  const currentVersion = versionMatches[0][1];
  const current = parseVersion(currentVersion);
  const today = getSingaporeDateParts(getNow());
  const sameDay = current.yy === today.yy && current.mmdd === today.mmdd;
  const nextCount = sameDay ? current.count + 1 : 1;
  const nextVersion = `${today.yy}.${today.mmdd}.${nextCount}`;

  const nextVersionSource = versionSource.replace(
    VERSION_DEFINE_PATTERN,
    `#!define VERSION "${nextVersion}"`
  );
  await fs.writeFile(VERSION_FILE, nextVersionSource, 'utf8');

  const readmeSource = await fs.readFile(README_FILE, 'utf8');
  const nextReadmeSource = readmeSource.replace(
    README_BADGE_PATTERN,
    `![](https://img.shields.io/static/v1?label=Version&message=${nextVersion}&color=blue&style=flat-square)`
  );

  if (nextReadmeSource === readmeSource) {
    throw new Error(`Failed to locate README version badge in ${README_FILE}`);
  }

  await fs.writeFile(README_FILE, nextReadmeSource, 'utf8');

  console.log(`Bumped VERSION: ${currentVersion} -> ${nextVersion}`);
}

main().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});
