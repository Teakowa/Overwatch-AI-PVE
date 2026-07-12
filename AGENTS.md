# AGENTS.md

This file is the minimal entrypoint for AI agents. Canonical rule bodies live under `docs/agents/*.md`.

## Goals

- Keep gameplay changes low risk and rollback-friendly.
- Preserve stable contracts for both entries: `src/main.opy` and `src/aramMain.opy`.
- Prevent server-load regressions in AI and hero rule paths.
- Enforce route-first, conditional context loading.

## Project Characteristics

- This repository is an Overwatch Workshop / OverPy project with one primary entry (`src/main.opy`) and one ARAM entry (`src/aramMain.opy`).
- Collaboration is contract-first: canonical constraints are registered in `docs/agents/rules-index.md` and implemented in `docs/agents/*.md`.
- High-risk change surfaces are include ordering, protocol index stability, hero init/reset chain integrity, and high-frequency AI/hero logic.
- Validation combines `pnpm` build/perf scripts and repo-local guard scripts in `tools/*.ts`.

## Minimal Red Lines

1. Do not casually reorder entry include flow.
2. Do not bypass required checks before handoff.
3. Do not default-load all docs; read only routed files for the task.
4. Do not introduce a new rule without registering it first in `docs/agents/rules-index.md`.

## Task-to-Doc Routing

Read only the documents needed by change scope:

| Change scope | Read first | Then read if needed |
| --- | --- | --- |
| Any change (baseline context) | `docs/agents/project-scope.md` | `docs/agents/rules-index.md` |
| `src/main.opy` or `src/modules/prelude/*` | `docs/agents/main-contract.md` | `docs/agents/protocol-constraints.md` |
| `src/modules/hero_init/*` | `docs/agents/hero-init-contract.md` | `docs/agents/protocol-constraints.md` |
| `src/modules/hero_rules/*` or high-frequency `src/modules/ai/*` | `docs/agents/performance-stability.md` | `docs/agents/protocol-constraints.md` |
| `src/aramMain.opy`, `src/aram_overrides*.opy`, or `src/heroes/*/shared/*.opy` | `docs/agents/performance-stability.md` | `docs/agents/protocol-constraints.md`, `docs/agents/gates-and-commits.md` |
| Pre-commit self-check | `docs/agents/self-checklist.md` | `docs/agents/gates-and-commits.md` |
| Gate execution and commit hygiene | `docs/agents/gates-and-commits.md` | `docs/agents/self-checklist.md` |

## On-Demand Read Protocol

1. Layer 1: touched files only.
2. Layer 2: direct dependencies (includes/config/constants referenced by Layer 1).
3. Layer 3: routed canonical docs in `docs/agents/` only.
4. Never default-load all `docs/agents/*` or all `docs/modules/*`.

## Canonical Rule Mapping

Use these as the only canonical policy sources:

1. Project scope and output boundaries -> `docs/agents/project-scope.md`
2. Main entry/include contracts -> `docs/agents/main-contract.md`
3. Protocol/index immutability constraints -> `docs/agents/protocol-constraints.md`
4. Hero init/reset contract -> `docs/agents/hero-init-contract.md`
5. Performance and stability guardrails -> `docs/agents/performance-stability.md`
6. Gate sequencing and commit constraints -> `docs/agents/gates-and-commits.md`
7. Pre-commit self checklist -> `docs/agents/self-checklist.md`
8. Rule registry and ownership mapping -> `docs/agents/rules-index.md`

## Workflow Command Pointers

- Dependency bootstrap:
  - `pnpm install --frozen-lockfile`

- Build/perf script surface:
  - `pnpm run build`
  - `pnpm run build:release`
  - `pnpm run build:release:all`
  - `pnpm run build:aram`
  - `pnpm run perf:scan`
  - `pnpm run perf:scan:strict`

- Release helpers:
  - `pnpm run tool:bump-version`
  - Release trigger: push to `main` (workflow auto-runs `pnpm run tool:bump-version`, builds `build/main.ow` and `build/aram.ow`, tags `v{VERSION}`, and publishes GitHub Release)
  - Release freshness guard: workflow skips stale runs when `github.sha` is not current `origin/main` head.
  - Release skip guard: include `[skip release]` in a `main` commit message to bypass release workflow.

- Contract and ARAM guards:
  - `tools/check-contracts.ts`
  - `tools/check-contracts.ts --build`
  - `tools/check-contracts.ts --strict-hero-init`
  - `tools/check-aram-overrides-duplicates.ts`
  - `tools/check-aram-overrides-duplicates.ts --check`
  - `tools/check-aram-overrides-duplicates.ts --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv`

- Hero/changelog linkage:
  - `tools/hero-pipeline.ts --hero freja`
  - `tools/hero-pipeline.ts --from-diff`
  - `tools/hero-pipeline.ts --from-diff --build`
  - `tools/hero-pipeline.ts --from-diff --strict-cooldown-placement`
  - `tools/hero-pipeline.ts --from-diff --report-template`
  - `tools/changelog-sync.ts --from-diff`
  - `tools/changelog-sync.ts --from-diff --strict-coverage --strict-language --strict-settings-sync`
  - `tools/changelog-sync.ts --from-diff --report`
  - `tools/changelog-sync.ts --hero freja --strict-coverage --strict-language`
  - `tools/changelog-sync.ts --hero jetpack_cat --strict-coverage --strict-language --strict-settings-sync`

- Fandom hero data:
  - `tools/fandom/fetch-heroes.ts --output /tmp/ow_heroes.json --pretty`
  - `tools/fandom/fetch-hero-details.ts --hero "Ana" --output /tmp/ana.json --pretty`
  - `tools/fandom/fetch-hero-details.ts --url URL --output /tmp/ana.json`
  - `tools/fandom/fetch-all-hero-details.ts --heroes-file /tmp/ow_heroes.json --output /tmp/ow_hero_details.json --pretty`
  - `tools/fandom/fetch-heroes.ts --html-file /path/to/Heroes.html --allowlist PATH --output /tmp/ow_heroes.json --pretty`
  - `tools/fandom/fetch-hero-details.ts --html-file /path/to/Ana.html --hero "Ana" --output /tmp/ana.json`
  - `tools/fandom/fetch-all-hero-details.ts --heroes-file /tmp/ow_heroes.json --html-dir /path/to/html-pages --output /tmp/ow_hero_details.json`

- Structure sync:
  - `tools/module-metrics-sync.ts`
  - `tools/module-metrics-sync.ts --check`
  - `tools/module-metrics-sync.ts --report`

- Hero sync guard:
  - `tools/player-constants-reachability.ts --prefix ANRAN_`
  - `tools/player-constants-reachability.ts --prefix ANRAN_ --apply`
  - `tools/player-constants-reachability.ts --global-cleanup --apply`
