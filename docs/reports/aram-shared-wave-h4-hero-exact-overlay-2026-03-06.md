# ARAM Shared Refactor H4 Wave-3 (Hero Overlay First Exact Cleanup) - 2026-03-06

## Scope

- Wave: H4 Wave-3
- Objective: clear remaining hero-side exact duplicates in `aram_overrides` by moving rule ownership to hero-local shared leaves and hero overlays.
- Policy:
  - hero rules only (skip bootstrap exact in this wave)
  - keep behavior unchanged for extracted rules
  - keep `aram_overrides` as orchestration layer via includes

## Files Changed

- Hero shared leaves:
  - `src/heroes/doomfist/shared/40-power-block-damage.opy`
  - `src/heroes/hazard/shared/60-spike-guard-using-tracking.opy`
  - `src/heroes/juno/shared/20-track-orbital-ray-position.opy`
  - `src/heroes/mauga/shared/60-berserker-soul-reset.opy`
  - `src/heroes/orisa/shared/10-fortify-ricochet-damage.opy`
  - `src/heroes/sigma/shared/20-ult-damage.opy`
  - `src/heroes/kiriko/shared/70-remove-swift-step-hp.opy`
  - `src/heroes/wuyang/shared/20-xuanwu-cd.opy`
  - `src/heroes/wuyang/shared/50-rushing-torrent.opy`
  - `src/heroes/wuyang/shared/70-ebb-and-flow-lost-control.opy`
- Hero rule/overlay wiring:
  - `src/heroes/{doomfist,hazard,juno,mauga,orisa,sigma,kiriko,wuyang}/rules.opy`
  - `src/heroes/{doomfist,hazard,juno,mauga,orisa,sigma,kiriko,wuyang}/aram.opy`
- ARAM assembly/governance:
  - `src/aram_overrides.opy`
  - `skills/ow-contract-guard/references/aram-delta-whitelist.tsv`
  - `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh`
  - `docs/aram-shared-refactor-todo.md`

## Key Changes

- Replaced 10 exact duplicate rule bodies in `aram_overrides` with hero overlay includes:
  - `heroes/doomfist/aram.opy`
  - `heroes/hazard/aram.opy`
  - `heroes/juno/aram.opy`
  - `heroes/mauga/aram.opy`
  - `heroes/orisa/aram.opy`
  - `heroes/sigma/aram.opy`
  - `heroes/kiriko/aram.opy`
  - `heroes/wuyang/aram.opy`
- Moved those 10 rule bodies to hero-owned `shared/*.opy` files and referenced them from both Main (`rules.opy`) and ARAM (`aram.opy`).
- Wuyang 3-rule exact set switched to single-point include (`heroes/wuyang/aram.opy`) per accepted wave policy.
- Removed corresponding 10 `rule_exact_duplicate` rows from whitelist.
- Expanded duplicates checker overlay scope from Wave-1 pilot heroes to all `src/heroes/*/aram*.opy` files.

## Validation Results

1. `pnpm run build` -> PASS
2. `pnpm run build:aram` -> PASS
3. `skills/ow-contract-guard/scripts/check_contracts.sh --build` -> PASS
4. `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init` -> PASS
5. `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero doomfist --hero hazard --hero juno --hero mauga --hero orisa --hero sigma --hero kiriko --hero wuyang --build` -> PASS (warnings only; no failures)
6. `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv` -> PASS

## Duplicate Metrics

- `total: 154`
- `exact: 1`
- `diff: 106`
- `unique: 47`
- `unwhitelisted exact/diff: 0/0`
- `candidates: 0`

## Conclusion

Wave-3 achieved the target contraction for hero exact duplicates:

- Hero exact duplicates in `aram_overrides` reduced from `11` to `1` (bootstrap-only residual).
- Hero rule ownership now sits under `src/heroes/<hero>/shared/*.opy` with mode reuse through `rules.opy` and `aram.opy`.
- Duplicate gate remains clean with full-hero overlay coverage.
