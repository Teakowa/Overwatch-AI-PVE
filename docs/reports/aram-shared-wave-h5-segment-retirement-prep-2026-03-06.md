# ARAM Shared Refactor H5 Prep (Segment Compile Dependency Retirement) - 2026-03-06

## Scope

- Wave: H5 Prep
- Objective: retire `src/aram_overrides_segments/*` from the active compile path without changing gameplay behavior.
- Policy:
  - do not proactively rebalance heroes
  - keep hero/main contracts and protocol indexes unchanged
  - allow cross-hero ARAM-only deltas to remain, but move them behind a single transitional include

## Files Changed

- Shared bootstrap extraction:
  - `src/modules/bootstrap/shared/10-setup-var-when-player-joins-lobby.opy`
  - `src/modules/bootstrap/20-player-lifecycle-and-reset.opy`
- ARAM assembly:
  - `src/aram_overrides.opy`
  - `src/aram_cross_hero_overrides.opy`
- Hero ARAM overlays:
  - `src/heroes/{mercy,ana,brigitte,kiriko,zenyatta,reinhardt,hazard,reaper,widowmaker,wuyang}/aram.opy`
- Governance/docs:
  - `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh`
  - `skills/ow-contract-guard/references/aram-delta-whitelist.tsv`
  - `docs/aram-shared-refactor-todo.md`

## Key Changes

- Replaced the final bootstrap exact duplicate with a shared bootstrap leaf included by both Main and ARAM.
- Removed all direct `#!include "aram_overrides_segments/*"` references from `src/aram_overrides.opy`.
- Moved every single-hero segment payload into the owning hero's `src/heroes/<hero>/aram.opy`.
- Added `src/aram_cross_hero_overrides.opy` as the only transitional container for the 4 remaining multi-hero ARAM-only clusters:
  - `genji + tracer`
  - `ramattra + wrecking_ball`
  - `sombra + tracer`
  - `wrecking_ball + zarya`
- Updated duplicate checks so the active scan surface is now:
  - `src/aram_overrides.opy`
  - `src/aram_cross_hero_overrides.opy`
  - `src/heroes/*/aram*.opy`
- Kept `src/aram_overrides_segments/manifest.tsv` as historical metadata only; it no longer participates in compile-path validation.

## Validation Results

1. `pnpm run build` -> PASS
2. `pnpm run build:aram` -> PASS
3. `skills/ow-contract-guard/scripts/check_contracts.sh --build` -> PASS
4. `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init` -> PASS
5. `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff --build` -> PASS (warnings only; no failures)
6. `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv` -> PASS
7. `rg '#!include "aram_overrides_segments/' src` -> PASS (no matches)

## Duplicate Metrics

- `src/aram_overrides.opy total: 153`
- `src/aram_overrides.opy exact/diff/unique: 0 / 106 / 47`
- `src/aram_cross_hero_overrides.opy total: 10`
- `src/aram_cross_hero_overrides.opy exact/diff/unique: 10 / 0 / 0`
- `src/heroes/*/aram*.opy exact/diff/unique: 28 / 2 / 0`
- `legacy segment includes in aram_overrides: 0`
- `residual contiguous exact runs >= 2 in aram_overrides: 0`
- `unwhitelisted aram/cross/overlay exact-diff: 0/0, 0/0, 0/0`
- `candidate rows emitted: 0`

## Conclusion

H5 Prep achieved the compile-path retirement target:

- `aram_overrides_segments` no longer participates in active ARAM assembly.
- Single-hero ARAM ownership is now anchored in `src/heroes/<hero>/aram.opy`.
- Remaining cross-hero technical debt is isolated to `src/aram_cross_hero_overrides.opy`.
- Bootstrap exact cleanup is complete, and `src/aram_overrides.opy` exact duplicates are reduced to zero.
