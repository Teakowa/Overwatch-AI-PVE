---
name: ow-hero-change-pipeline
description: Run a safe, repeatable hero change workflow for Overwatch-AI-PVE Workshop edits. Use when adding or modifying hero_init or hero_rules logic, touching hero includes, changing reset_pvar interactions, or updating changelog coverage for specific heroes.
---

# OW Hero Change Pipeline

Use this skill to reduce hero-change regressions.

## Quick Start

Audit one hero:

```bash
skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero freja
```

Audit heroes inferred from current diff:

```bash
skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff
```

Run with build gate and contract guard:

```bash
skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff --build
```

Generate review report template:

```bash
skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff --report-template
```

## What It Checks

For each hero, the pipeline checks:

1. `hero_init/heroes/<hero>.opy` exists and is included by `hero_init/_index.opy`.
2. Detect/Initialize safety pattern:
   - has `reset_pvar[0] = true`
   - has `resetHero()`
   - has `reset_pvar[0] = false`
   - has initialize gate condition (`!= false` or `== true`)
3. `hero_rules` touchpoint:
   - checks whether hero appears in `hero_rules` annotations/usages
4. Changelog touchpoint:
   - checks whether `debug/20-changelog.opy` has `eventPlayer.getHero() == Hero.<X>` branch
5. `reset_pvar` semantic checks inside hero init:
   - validates known slot set
   - enforces `reset_pvar[0]` boolean semantics (`true` / `false`)
   - checks slot owner expectations for key slots (for example `1 -> brigitte`, `11 -> freja`)
   - checks team direction expectations (ally/enemy slot mapping)
   - validates nested chain pattern (`reset_pvar[6].reset_pvar[9]`)
6. `hero_rules` throttle risk checks:
   - scans touched `eachPlayer` blocks
   - warns on expensive/high-frequency patterns without `wait` or `waitUntil`
   - warns/fails on loop/while blocks without throttling wait
7. Review report template output:
   - emits a markdown review template with automated findings and manual checklist
   - default output path: `docs/reports/hero-pipeline-review-<timestamp>.md`

## Workflow

1. Run pipeline before edits to learn current baseline.
2. Implement hero changes in `hero_init` and/or `hero_rules`.
3. Run pipeline again until no blocking failures remain.
4. Run `ow-contract-guard` and build before commit.

Recommended final gate:

```bash
skills/ow-contract-guard/scripts/check_contracts.sh --build
```

## Notes

- Missing changelog branch is a warning by default. Use `--strict-changelog` to make it blocking.
- Missing hero_rules touchpoint is a warning by default. Use `--strict-rules` to make it blocking.
- Throttle risks are warnings by default. Use `--strict-throttle` to make them blocking.
- Use `--report-template [path]` to generate a reusable review report template.
