# ARAM Shared Refactor H4 Wave-1 (Hero Init Detect Pilot) - 2026-03-06

## Scope

- Wave: H4 Wave-1
- Objective: clean hero_init exact duplicates by extracting Detect rules first.
- Pilot heroes: `reaper`, `tracer`, `mercy`, `hanzo`, `freja`, `torbjorn`.
- Out of scope: Initialize same-name-diff convergence, balance changes, index protocol changes.

## Files Changed

- Detect leaves (new):
  - `src/heroes/reaper/init-detect.opy`
  - `src/heroes/tracer/init-detect.opy`
  - `src/heroes/mercy/init-detect.opy`
  - `src/heroes/hanzo/init-detect.opy`
  - `src/heroes/freja/init-detect.opy`
  - `src/heroes/torbjorn/init-detect.opy`
- Hero init include updates:
  - `src/heroes/reaper/init.opy`
  - `src/heroes/tracer/init.opy`
  - `src/heroes/mercy/init.opy`
  - `src/heroes/hanzo/init.opy`
  - `src/heroes/freja/init.opy`
  - `src/heroes/torbjorn/init.opy`
- ARAM replacement:
  - `src/aram_overrides.opy` (6 Detect exact blocks replaced in place with include)
- Guardrails:
  - `skills/ow-contract-guard/references/aram-delta-whitelist.tsv` (removed 6 exact rows)
  - `skills/ow-contract-guard/scripts/check_contracts.sh`
  - `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh`
  - `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh`
- Docs:
  - `docs/aram-shared-refactor-todo.md`

## Metric Delta

- Baseline: `exact=53`, `diff=148`, `unique=49`, `unwhitelisted exact/diff=0/0`
- After Wave-1: `exact=47`, `diff=148`, `unique=49`, `unwhitelisted exact/diff=0/0`
- Candidates rows: `0`
- Pilot overlay scope (`src/heroes/<hero>/aram*.opy` for 6 heroes): `0` items, `unwhitelisted 0/0`

## Validation Results

1. `pnpm run build` -> PASS (existing warnings only)
2. `pnpm run build:aram` -> PASS (existing warnings only)
3. `skills/ow-contract-guard/scripts/check_contracts.sh --build` -> PASS
4. `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init` -> PASS
5. `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero reaper --hero tracer --hero mercy --hero hanzo --hero freja --hero torbjorn --build` -> PASS (non-blocking warnings: existing changelog/cooldown hints)
6. `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv` -> PASS

## Behavior Equivalence

- The 6 pilot changes are code ownership moves only:
  - Detect blocks were extracted to shared hero-local leaves.
  - `aram_overrides` keeps original order via in-place include replacement.
  - Initialize bodies and ARAM-specific Initialize diffs were not changed.
- Contract checks (including strict hero-init) confirm Detect/Initialize pairing remains valid after include split.

## Conclusion

H4 Wave-1 acceptance criteria are satisfied:

- `exact=47`, `diff=148`, `unwhitelisted exact/diff=0/0`, `candidates=0`.
- 6-hero detect-first pilot completed with no behavior change and no contract regressions.
- Ready to continue H4 with next batch (Initialize diffs / overlay relocation).
