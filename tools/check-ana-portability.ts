#!/usr/bin/env -S node --import tsx

import fs from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { readText, resolveRepo, runCommand } from "./lib/runtime.js";

const failures: string[] = [];

function pass(message: string): void {
  console.log("[PASS] " + message);
}

function fail(message: string): void {
  failures.push(message);
  console.error("[FAIL] " + message);
}

function requireText(label: string, text: string, needle: string): void {
  if (text.includes(needle)) {
    pass(label);
  } else {
    fail(label + ": missing " + JSON.stringify(needle));
  }
}

function requireExactLine(label: string, text: string, line: string, expected: number): void {
  const actual = text.split(/\r?\n/).filter((candidate) => candidate === line).length;
  if (actual === expected) {
    pass(label);
  } else {
    fail(label + ": expected " + expected + " exact line(s), found " + actual);
  }
}

async function runMinimalFixture(ability2Path: string, policyPath: string): Promise<void> {
  const fixtureRoot = await fs.mkdtemp(path.join(os.tmpdir(), "owbastion-ana-portability-"));
  try {
    const fixtureSrc = path.join(fixtureRoot, "src");
    const fixtureAbility = path.join(fixtureSrc, "heroes", "ana", "ability2.opy");
    const fixturePolicy = path.join(fixtureSrc, "modules", "combat-policy", "custom-effect-guards.opy");
    await fs.mkdir(path.dirname(fixtureAbility), { recursive: true });
    await fs.mkdir(path.dirname(fixturePolicy), { recursive: true });
    await fs.mkdir(path.join(fixtureRoot, "build"), { recursive: true });
    await fs.copyFile(ability2Path, fixtureAbility);
    await fs.copyFile(policyPath, fixturePolicy);
    await fs.writeFile(
      path.join(fixtureSrc, "main.opy"),
      [
        "#!optimizeStrict",
        "#!define ANA_ABILITY2_BURNING_DURATION 3",
        "#!define ANA_ABILITY2_DOT_DURATION 3",
        "macro isHero(player, hero):",
        "    (player.getHero() == hero)",
        "macro Number.percentOf(p):",
        "    self * (p) / 100",
        "macro Player.maxHealthPercent(percent):",
        "    self.getMaxHealth().percentOf(percent)",
        "globalvar Ana_GrenadeDamage",
        "playervar has_nano",
        "playervar zarya_buff",
        '#!include "modules/combat-policy/custom-effect-guards.opy"',
        '#!include "heroes/ana/ability2.opy"',
        "",
      ].join("\n"),
      "utf8",
    );
    runCommand(
      resolveRepo("node_modules/.bin/overpy"),
      ["compile", "-i", "src/main.opy", "--root", "src", "-l", "zh-CN", "-o", "build/ana-portability.ow"],
      { cwd: fixtureRoot },
    );
    pass("minimal Ana Biotic Grenade fixture compiles without prelude registries");
  } finally {
    await fs.rm(fixtureRoot, { recursive: true, force: true });
  }
}

async function main(): Promise<void> {
  const ability2Path = resolveRepo("src/heroes/ana/ability2.opy");
  const settingsPath = resolveRepo("src/heroes/ana/settings.opy");
  const settingsAramPath = resolveRepo("src/heroes/ana/settings.aram.opy");
  const policyPath = resolveRepo("src/modules/combat-policy/custom-effect-guards.opy");
  const preludeGlobalsPath = resolveRepo("src/modules/prelude/global-vars.opy");

  const [ability2, settings, settingsAram, policy, preludeGlobals] =
    await Promise.all([
      readText(ability2Path),
      readText(settingsPath),
      readText(settingsAramPath),
      readText(policyPath),
      readText(preludeGlobalsPath),
    ]);

  requireText("Ana rule has its module mainFile directive", ability2, '#!mainFile "../../main.opy"');
  requireExactLine("Main Ana settings owns Ana_GrenadeDamage", settings, "globalvar Ana_GrenadeDamage", 1);
  requireExactLine("Main Ana settings owns Ana_NanoHealAmp", settings, "globalvar Ana_NanoHealAmp", 1);
  requireExactLine("ARAM Ana settings owns Ana_GrenadeDamage", settingsAram, "globalvar Ana_GrenadeDamage", 1);
  requireText("Ana Biotic Grenade uses its owned setting", ability2, "victim.maxHealthPercent(Ana_GrenadeDamage[0])");
  requireText("Ana Biotic Grenade exposes the protection policy call", ability2, "if victim.blocksCustomDot():");
  requireText("Ana Biotic Grenade explicitly applies the engine burning status", ability2, "Status.BURNING");
  requireText("Ana Biotic Grenade keeps the invincible/phased-out gate", ability2, "victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.PHASED_OUT)");
  requireText("Ana Biotic Grenade keeps the Nano gate", ability2, "victim.has_nano != true");
  requireText("Combat policy owns the cross-hero storage read", policy, "macro Player.blocksCustomDot():");
  requireExactLine("Combat policy is the only direct zarya_buff storage guard", policy, "    self.zarya_buff[1] != null", 1);

  if (/\bAna_(?:GrenadeDamage|NanoHealAmp)\b/.test(preludeGlobals)) {
    fail("Ana-owned globals leaked back into modules/prelude/global-vars.opy");
  } else {
    pass("Ana-owned globals are absent from the global prelude registry");
  }
  if (/\bzarya_buff\b/.test(ability2)) {
    fail("Ana Biotic Grenade directly reads zarya_buff instead of the policy boundary");
  } else {
    pass("Ana Biotic Grenade has no direct zarya_buff storage read");
  }
  if (settingsAram.includes("Ana_NanoHealAmp")) {
    fail("ARAM Ana settings unexpectedly require the Main-only NanoHealAmp setting");
  } else {
    pass("ARAM Biotic Grenade settings do not require Main-only NanoHealAmp state");
  }

  if (failures.length === 0) {
    await runMinimalFixture(ability2Path, policyPath);
  }

  if (failures.length > 0) {
    throw new Error("Ana portability check failed with " + failures.length + " failure(s)");
  }
  console.log("Ana portability check passed");
}

main().catch((error: unknown) => {
  console.error(error instanceof Error ? error.message : String(error));
  process.exitCode = 1;
});
