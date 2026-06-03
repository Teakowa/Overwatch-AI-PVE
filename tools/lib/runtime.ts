import fsSync from "node:fs";
import fs from "node:fs/promises";
import path from "node:path";
import process from "node:process";
import { spawnSync } from "node:child_process";

export function failHard(message: string): never {
  throw new Error(message);
}

export async function exists(targetPath: string): Promise<boolean> {
  try {
    await fs.access(targetPath);
    return true;
  } catch {
    return false;
  }
}

export function existsSync(targetPath: string): boolean {
  return fsSync.existsSync(targetPath);
}

export function findRepoRoot(start = process.cwd()): string {
  let current = path.resolve(start);
  while (true) {
    const pkg = path.join(current, "package.json");
    const git = path.join(current, ".git");
    if (existsSync(pkg) && existsSync(git)) {
      return current;
    }
    const parent = path.dirname(current);
    if (parent === current) {
      failHard(`Unable to locate repo root from ${start}`);
    }
    current = parent;
  }
}

export const repoRoot = findRepoRoot();

export function resolveRepo(...segments: string[]): string {
  return path.join(repoRoot, ...segments);
}

export function relRepo(targetPath: string): string {
  return path.relative(repoRoot, targetPath) || ".";
}

export async function readText(filePath: string): Promise<string> {
  return fs.readFile(filePath, "utf8");
}

export async function readLines(filePath: string): Promise<string[]> {
  return (await readText(filePath)).split(/\r?\n/);
}

export async function ensureDir(dirPath: string): Promise<void> {
  await fs.mkdir(dirPath, { recursive: true });
}

export async function writeText(filePath: string, content: string): Promise<void> {
  await ensureDir(path.dirname(filePath));
  await fs.writeFile(filePath, content, "utf8");
}

export function escapeRegex(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

export function countFixedMatches(text: string, needle: string): number {
  if (!needle) {
    return 0;
  }
  return (text.match(new RegExp(escapeRegex(needle), "g")) || []).length;
}

export function firstFixedMatchLine(lines: string[], needle: string): number | null {
  for (let index = 0; index < lines.length; index += 1) {
    if (lines[index].includes(needle)) {
      return index + 1;
    }
  }
  return null;
}

export function countRegexLines(lines: string[], pattern: RegExp): number {
  return lines.filter((line) => pattern.test(line)).length;
}

export function uniqueSorted(values: Iterable<string>): string[] {
  return [...new Set(values)].sort((a, b) => a.localeCompare(b));
}

export function listOpyFiles(rootPath: string): string[] {
  const files: string[] = [];
  const stack = [rootPath];
  while (stack.length > 0) {
    const current = stack.pop()!;
    const entries = spawnSync("find", [current, "-mindepth", "1", "-maxdepth", "1"], {
      cwd: repoRoot,
      encoding: "utf8",
    });
    if (entries.status !== 0) {
      continue;
    }
    for (const entry of entries.stdout.split("\n").filter(Boolean)) {
      try {
        const stat = spawnSync("test", ["-d", entry]);
        if (stat.status === 0) {
          stack.push(entry);
          continue;
        }
      } catch {
        // ignore
      }
      if (entry.endsWith(".opy")) {
        files.push(entry);
      }
    }
  }
  return files.sort((a, b) => a.localeCompare(b));
}

export function runCommand(
  command: string,
  args: string[],
  options: {
    cwd?: string;
    allowFailure?: boolean;
    input?: string;
    env?: NodeJS.ProcessEnv;
  } = {},
): string {
  const result = spawnSync(command, args, {
    cwd: options.cwd ?? repoRoot,
    encoding: "utf8",
    input: options.input,
    env: options.env ? { ...process.env, ...options.env } : process.env,
  });
  if (result.status !== 0 && !options.allowFailure) {
    const stderr = result.stderr?.trim();
    const stdout = result.stdout?.trim();
    throw new Error(
      [`Command failed: ${command} ${args.join(" ")}`, stderr, stdout]
        .filter(Boolean)
        .join("\n"),
    );
  }
  return result.stdout ?? "";
}

export function tryCommand(command: string, args: string[], cwd?: string): string {
  return runCommand(command, args, { cwd, allowFailure: true });
}

export function gitDiffNameOnly(range: string, extraArgs: string[] = []): string[] {
  const output = tryCommand("git", ["diff", "--name-only", range, "--", ...extraArgs], repoRoot);
  return output
    .split("\n")
    .map((line) => line.trim())
    .filter(Boolean);
}

export async function chmodExecutable(filePath: string): Promise<void> {
  await fs.chmod(filePath, 0o755);
}
