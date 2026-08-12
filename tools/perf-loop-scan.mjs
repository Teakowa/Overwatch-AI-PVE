import fs from "node:fs/promises";
import path from "node:path";
import process from "node:process";
import { fileURLToPath } from "node:url";

const DEFAULT_TARGETS = ["src"];
const SOURCE_EXTENSIONS = new Set([".opy"]);
const LOOP_WAIT_WINDOW = 10;
const SELF_TEST_FIXTURE_DIR = "tools/fixtures/perf";
const HIGH_FREQ_EVENTS = new Set(["playerTookDamage", "playerDealtDamage", "playerDealtKnockback"]);
const CHEAP_GATE_PATTERN = /(isAlive\(|isDummy\(|hasSpawned\(|isMoving\(|isInSpawnRoom\(|getAbilityCooldown\(|getUltCharge\(|isUsingUltimate\(|eventAbility\s*==|eventAbility\s*!=|eventPlayer\s*!=\s*null|eventPlayer\s*==\s*null|entityExists\()/;
const EXPENSIVE_CONDITION_PATTERN = /(getPlayersInRadius\(|getPlayersWithinRadius\(|getLivingPlayers\(|getPlayersOnObjective\(|getPlayersOnHero\(|sorted\(|distance\(|isInLoS\(|\.filter\(|\.map\(|\.sorted\()/;
const PHASE_CONDITION_PATTERN = /(isMatchBetweenRounds|isInSetup|isWaitingForPlayers|hasStatus\()/;
const PERSISTENT_START_PATTERN = /start(HealingOverTime|DamageOverTime|ForcingButton|HoldingButton|Acceleration|Chase|Facing)\s*\(/;
const PERSISTENT_STOP_PATTERN = /stop(HealingOverTime|DamageOverTime|ForcingButton|HoldingButton|Acceleration|Chase|Facing|AllDamageOverTime)\s*\(|stopAllHealingModifications\s*\(/;
const STORED_HANDLE_PATTERN = /getLastCreated(HealthPool|DamageOverTime|HealingOverTime)\(|(_id|_buff|_handle)\b/;
const QUERY_CALL_PATTERN = /(getPlayersOnHero|getPlayersInRadius|getPlayersWithinRadius|getLivingPlayers|getPlayersOnObjective|getPayloadPosition|getPayloadProgressPercentage|getPlayers)\s*\(/g;
const __filename = fileURLToPath(import.meta.url);

function isFlag(value) {
  return value.startsWith("--");
}

function parseArgs(argv) {
  let strict = false;
  let selfTest = false;
  const targets = [];

  for (const arg of argv) {
    if (arg === "--strict") {
      strict = true;
      continue;
    }
    if (arg === "--self-test") {
      selfTest = true;
      continue;
    }
    if (isFlag(arg)) {
      throw new Error(`Unknown option: ${arg}`);
    }
    targets.push(arg);
  }

  return {
    strict,
    selfTest,
    targets: targets.length > 0 ? targets : DEFAULT_TARGETS,
  };
}

async function pathExists(targetPath) {
  try {
    await fs.access(targetPath);
    return true;
  } catch {
    return false;
  }
}

async function collectFiles(targetPath, files, warnings) {
  const resolved = path.resolve(process.cwd(), targetPath);
  const exists = await pathExists(resolved);
  if (!exists) {
    warnings.push(`Missing scan target: ${targetPath}`);
    return;
  }

  const stat = await fs.stat(resolved);
  if (stat.isDirectory()) {
    const entries = await fs.readdir(resolved, { withFileTypes: true });
    for (const entry of entries) {
      const nested = path.join(resolved, entry.name);
      if (entry.isDirectory()) {
        await collectFiles(nested, files, warnings);
        continue;
      }
      if (SOURCE_EXTENSIONS.has(path.extname(entry.name))) {
        files.push(nested);
      }
    }
    return;
  }

  files.push(resolved);
}

function toRel(filePath) {
  return path.relative(process.cwd(), filePath) || ".";
}

function makeFinding(filePath, line, type, detail, severity = "MEDIUM") {
  return {
    file: toRel(filePath),
    line,
    type,
    detail,
    severity,
  };
}

function isComment(line) {
  return line.trimStart().startsWith("#");
}

function hasNearbyWait(lines, index) {
  const start = Math.max(0, index - LOOP_WAIT_WINDOW);
  const end = Math.min(lines.length - 1, index + LOOP_WAIT_WINDOW);
  for (let i = start; i <= end; i += 1) {
    if (isComment(lines[i])) {
      continue;
    }
    if (/\bwait\s*\(/.test(lines[i])) {
      return true;
    }
  }
  return false;
}

function getRuleBlocks(lines) {
  const blocks = [];
  let active = null;

  for (let i = 0; i < lines.length; i += 1) {
    if (/^\s*rule\s+["'`]/.test(lines[i])) {
      if (active) {
        active.end = i - 1;
        blocks.push(active);
      }
      active = {
        start: i,
        end: lines.length - 1,
        lines: [],
      };
    }
    if (active) {
      active.lines.push({ lineNo: i + 1, text: lines[i] });
    }
  }

  if (active) {
    blocks.push(active);
  }

  return blocks;
}

function extractCallExpressions(text, pattern) {
  const calls = [];
  const matches = [...text.matchAll(pattern)];
  for (const match of matches) {
    const start = match.index;
    let depth = 0;
    for (let i = start; i < text.length; i += 1) {
      if (text[i] === "(") {
        depth += 1;
      } else if (text[i] === ")") {
        depth -= 1;
        if (depth === 0) {
          calls.push(text.slice(start, i + 1));
          break;
        }
      }
    }
  }
  return calls;
}

function scanRuleBlock(filePath, block) {
  const findings = [];
  const eventLine = block.lines.find((item) => /@Event\b/.test(item.text) && !isComment(item.text));
  if (!eventLine) {
    return findings;
  }
  const eventMatch = eventLine.text.match(/@Event\s+(\w+)/);
  const eventType = eventMatch ? eventMatch[1] : "unknown";

  const conditionLines = block.lines.filter((item) => /@Condition\b/.test(item.text) && !isComment(item.text));
  const bodyLines = block.lines.filter(
    (item) => !isComment(item.text) && !/@(Event|Team|Hero|Slot|Condition)\b/.test(item.text),
  );

  // Existing check: heavy condition before a cheap gate in Ongoing rules.
  if ((eventType === "eachPlayer" || eventType === "global") && conditionLines.length >= 2) {
    const heavyPattern =
      /(distance\(|sorted\(|getLivingPlayers\(|getPlayersInRadius\(|getPlayersWithinRadius\(|\.filter\(|\.sorted\()/;
    let firstCheap = null;
    let firstHeavy = null;

    for (const condition of conditionLines) {
      if (firstCheap === null && CHEAP_GATE_PATTERN.test(condition.text)) {
        firstCheap = condition;
      }
      if (firstHeavy === null && heavyPattern.test(condition.text)) {
        firstHeavy = condition;
      }
    }

    if (firstHeavy && firstCheap && firstHeavy.lineNo < firstCheap.lineNo) {
      findings.push(
        makeFinding(
          filePath,
          firstHeavy.lineNo,
          "ONGOING_GATING_ORDER",
          `Heavy condition appears before cheaper gate in @Event ${eventType}.`,
          "MEDIUM",
        ),
      );
    }
  }

  // High-frequency event rules with expensive condition-level queries.
  if (HIGH_FREQ_EVENTS.has(eventType)) {
    let firstCheap = null;
    let firstHeavy = null;
    for (const condition of conditionLines) {
      if (firstCheap === null && CHEAP_GATE_PATTERN.test(condition.text)) {
        firstCheap = condition;
      }
      if (firstHeavy === null && EXPENSIVE_CONDITION_PATTERN.test(condition.text)) {
        firstHeavy = condition;
      }
    }
    if (firstHeavy) {
      const gated = firstCheap !== null && firstCheap.lineNo < firstHeavy.lineNo;
      findings.push(
        makeFinding(
          filePath,
          firstHeavy.lineNo,
          "EVENT_EXPENSIVE_CONDITION",
          `@Event ${eventType} condition contains an expensive spatial/player query${
            gated ? " (cheap gate precedes)" : " before any cheap gate"
          }.`,
          gated ? "LOW" : "MEDIUM",
        ),
      );
    }
  }

  // Repeated equivalent query within a single rule (advisory).
  const queryCounts = new Map();
  for (const item of block.lines) {
    if (isComment(item.text)) {
      continue;
    }
    for (const call of extractCallExpressions(item.text, QUERY_CALL_PATTERN)) {
      const normalized = call.replace(/\s+/g, "");
      const entry = queryCounts.get(normalized) || { count: 0, lineNo: item.lineNo };
      entry.count += 1;
      queryCounts.set(normalized, entry);
    }
  }
  for (const [call, entry] of queryCounts) {
    if (entry.count >= 2) {
      findings.push(
        makeFinding(
          filePath,
          entry.lineNo,
          "REPEATED_QUERY",
          `Equivalent query repeated ${entry.count} times within the rule: ${call}`,
          "LOW",
        ),
      );
    }
  }

  // Persistent-action lifecycle hazard in Ongoing rules (conservative warning).
  if (eventType === "eachPlayer" || eventType === "global") {
    const hasPhaseCondition = conditionLines.some((item) => PHASE_CONDITION_PATTERN.test(item.text));
    const startLines = bodyLines
      .map((item) => ({ lineNo: item.lineNo, match: item.text.match(PERSISTENT_START_PATTERN) }))
      .filter((entry) => entry.match);
    if (hasPhaseCondition && startLines.length > 0) {
      const hasStop = bodyLines.some((item) => PERSISTENT_STOP_PATTERN.test(item.text));
      const hasHandle = bodyLines.some((item) => STORED_HANDLE_PATTERN.test(item.text));
      if (!hasStop && !hasHandle) {
        const kinds = [...new Set(startLines.map((entry) => entry.match[1]))].join(", ");
        findings.push(
          makeFinding(
            filePath,
            startLines[0].lineNo,
            "PERSISTENT_ACTION_LIFECYCLE",
            `Long-lived ${kinds} started from a phase-gated Ongoing rule with no in-rule stop or stored handle.`,
            "LOW",
          ),
        );
      }
    }
  }

  return findings;
}

function scanSource(filePath, content) {
  if (path.extname(filePath) !== ".opy") {
    return [];
  }

  const findings = [];
  const lines = content.split(/\r?\n/);

  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i];
    if (isComment(line)) {
      continue;
    }

    if (/\bloop\s*\(/.test(line) && !hasNearbyWait(lines, i)) {
      findings.push(
        makeFinding(filePath, i + 1, "WAITLESS_LOOP_RISK", "Found loop(...) without nearby wait(...) throttle.", "HIGH"),
      );
    }

    if (/\bwhile\s+.+:/.test(line) && !hasNearbyWait(lines, i)) {
      findings.push(
        makeFinding(filePath, i + 1, "WAITLESS_WHILE_RISK", "Found while-loop without nearby wait(...) throttle.", "HIGH"),
      );
    }

    if (/\bdistance\s*\(/.test(line)) {
      findings.push(makeFinding(filePath, i + 1, "HOTSPOT_DISTANCE", "distance(...) call in rule flow.", "LOW"));
    }
    if (/\bsorted\s*\(/.test(line)) {
      findings.push(makeFinding(filePath, i + 1, "HOTSPOT_SORTED", "sorted(...) call in rule flow.", "LOW"));
    }
    if (/\bgetLivingPlayers\s*\(/.test(line)) {
      findings.push(
        makeFinding(filePath, i + 1, "HOTSPOT_PLAYER_SCAN", "getLivingPlayers(...) array scan in rule flow.", "LOW"),
      );
    }
    if (/\.(filter|sorted|map)\s*\(/.test(line) && /\.(filter|sorted)\s*\(/.test(line)) {
      findings.push(
        makeFinding(
          filePath,
          i + 1,
          "HOTSPOT_CHAINED_ARRAY_OPS",
          "Chained array operations detected; verify selectivity gating.",
          "LOW",
        ),
      );
    }
  }

  const ruleBlocks = getRuleBlocks(lines);
  for (const block of ruleBlocks) {
    findings.push(...scanRuleBlock(filePath, block));
  }

  return findings;
}

function groupFindings(findings) {
  const risk = findings.filter((f) => f.severity === "HIGH");
  const hotspots = findings.filter((f) => f.type.startsWith("HOTSPOT_"));
  const lifecycle = findings.filter((f) => f.type === "PERSISTENT_ACTION_LIFECYCLE");
  const suggestions = findings.filter(
    (f) => f.severity !== "HIGH" && !f.type.startsWith("HOTSPOT_") && f.type !== "PERSISTENT_ACTION_LIFECYCLE",
  );
  return { risk, hotspots, lifecycle, suggestions };
}

function formatEntry(entry) {
  return `- [${entry.severity}] ${entry.type} ${entry.file}:${entry.line} -> ${entry.detail}`;
}

function printSection(title, entries) {
  console.log(`${title}:`);
  if (entries.length === 0) {
    console.log("- none");
    return;
  }
  for (const entry of entries) {
    console.log(formatEntry(entry));
  }
}

function printSummary(totalFiles, findings, strict) {
  const high = findings.filter((f) => f.severity === "HIGH").length;
  const medium = findings.filter((f) => f.severity === "MEDIUM").length;
  const low = findings.filter((f) => f.severity === "LOW").length;
  console.log("Summary:");
  console.log(`- files scanned: ${totalFiles}`);
  console.log(`- findings: ${findings.length} (HIGH=${high}, MEDIUM=${medium}, LOW=${low})`);
  console.log(`- strict mode: ${strict ? "on" : "off"}`);
}

export async function main(argv = process.argv.slice(2)) {
  const { strict, selfTest, targets } = parseArgs(argv);

  if (selfTest) {
    const failed = await runSelfTest();
    process.exitCode = failed ? 1 : 0;
    return;
  }

  const files = [];
  const warnings = [];

  for (const target of targets) {
    await collectFiles(target, files, warnings);
  }

  const uniqueFiles = [...new Set(files)].sort();
  const findings = [];
  for (const filePath of uniqueFiles) {
    const content = await fs.readFile(filePath, "utf8");
    findings.push(...scanSource(filePath, content));
  }

  const grouped = groupFindings(findings);

  console.log("Performance Loop Scan Report");
  console.log(`Targets: ${targets.join(", ")}`);
  if (warnings.length > 0) {
    console.log("Warnings:");
    for (const warning of warnings) {
      console.log(`- ${warning}`);
    }
  }
  printSection("Risk", grouped.risk);
  printSection("Hotspots", grouped.hotspots);
  printSection("Lifecycle", grouped.lifecycle);
  printSection("Suggestions", grouped.suggestions);
  printSummary(uniqueFiles.length, findings, strict);

  if (strict && grouped.risk.length > 0) {
    process.exitCode = 1;
  }
}

async function runSelfTest() {
  const fixtureDir = path.resolve(process.cwd(), SELF_TEST_FIXTURE_DIR);
  const manifestPath = path.join(fixtureDir, "manifest.json");
  const manifest = JSON.parse(await fs.readFile(manifestPath, "utf8"));
  let failed = false;

  console.log("Perf Loop Scan Self-Test");
  for (const [fixture, expected] of Object.entries(manifest)) {
    const fixturePath = path.join(fixtureDir, fixture);
    const content = await fs.readFile(fixturePath, "utf8");
    const findings = scanSource(fixturePath, content);

    const expectedTypes = new Set(expected.map((entry) => entry.type));
    const unexpected = findings.filter((finding) => !expectedTypes.has(finding.type));
    const missing = expected.filter(
      (entry) =>
        !findings.some(
          (finding) =>
            finding.type === entry.type &&
            (entry.severity === undefined || finding.severity === entry.severity),
        ),
    );

    const fixtureStatus = unexpected.length === 0 && missing.length === 0;
    if (!fixtureStatus) {
      failed = true;
    }
    console.log(`- [${fixtureStatus ? "PASS" : "FAIL"}] ${fixture}`);
    for (const finding of findings) {
      console.log(`    ${formatEntry(finding)}`);
    }
    if (missing.length > 0) {
      console.log(`    expected: ${missing.map((entry) => entry.type).join(", ")}`);
    }
    if (unexpected.length > 0) {
      console.log(`    unexpected: ${unexpected.map((finding) => finding.type).join(", ")}`);
    }
  }

  console.log(`Self-test ${failed ? "FAILED" : "passed"}.`);
  return failed;
}

const invokedPath = process.argv[1] ? path.resolve(process.argv[1]) : null;
if (invokedPath === __filename) {
  main().catch((error) => {
    console.error(error.message);
    process.exitCode = 1;
  });
}
