# ARAM Shared Refactor H5 Wave-N (Cross-Hero Exact Cleanup + Legacy Directory Retirement) - 2026-03-06

## Scope

- Wave: H5 Wave-N
- Objective: remove the last cross-hero exact transitional layer and delete the retired `aram_overrides_segments` directory.
- Policy:
  - do not rebalance gameplay
  - preserve Main and ARAM rule ordering at the include site
  - keep remaining `same_name_diff` debt in place for later waves

## Files Changed

- Hero-owned shared leaves:
  - `src/heroes/genji/shared/*.opy`
  - `src/heroes/tracer/shared/*.opy`
  - `src/heroes/ramattra/shared/*.opy`
  - `src/heroes/wrecking_ball/shared/*.opy`
  - `src/heroes/sombra/shared/*.opy`
  - `src/heroes/zarya/shared/*.opy`
- Assembly and rule ownership:
  - `src/aram_overrides.opy`
  - `src/heroes/{genji,tracer,ramattra,wrecking_ball,sombra,zarya}/rules*.opy`
- Governance/docs:
  - `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh`
  - `skills/ow-contract-guard/references/aram-delta-whitelist.tsv`
  - `docs/aram-shared-refactor-todo.md`
- Retired artifacts removed:
  - `src/aram_cross_hero_overrides.opy`
  - `src/aram_overrides_segments/`

## Key Changes

- Moved the 10 cross-hero exact rules from the transitional file into hero-owned `shared/*.opy` leaves.
- Rewired Main rule files to include those shared leaves in-place, preserving existing hero rule order.
- Rewired `src/aram_overrides.opy` to include the same shared leaves in the exact former cross-hero order, preserving ARAM assembly order.
- Deleted `src/aram_cross_hero_overrides.opy`; no active ARAM assembly now depends on a separate cross-hero transitional file.
- Deleted the full `src/aram_overrides_segments/` directory and removed duplicates-tool dependence on `manifest.tsv`.
- Tightened duplicate checks so they now validate:
  - active `src/aram_overrides.opy`
  - active `src/heroes/*/aram*.opy`
  - absence of retired assembly references in `src/`

## Validation Results

1. `pnpm run build` -> PASS
2. `pnpm run build:aram` -> PASS
3. `skills/ow-contract-guard/scripts/check_contracts.sh --build` -> PASS
4. `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init` -> PASS
5. `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff --build` -> PASS (warnings only; no failures)
6. `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv` -> PASS
7. `rg 'aram_cross_hero_overrides|aram_overrides_segments' src skills` -> PASS (`src/` clean; `skills/` retains only retirement-aware script text)

## Duplicate Metrics

- `src/aram_overrides.opy total: 153`
- `src/aram_overrides.opy exact/diff/unique: 0 / 106 / 47`
- `src/heroes/*/aram*.opy exact/diff/unique: 28 / 2 / 0`
- `retired assembly references in src: 0`
- `residual contiguous exact runs >= 2 in aram_overrides: 0`
- `unwhitelisted aram/overlay exact-diff: 0/0, 0/0`
- `candidate rows emitted: 0`

## Conclusion

This wave removes the last structural transitional layer from active ARAM assembly:

- cross-hero exact ownership is now fully expressed through hero-owned shared leaves
- `aram_overrides_segments` is fully retired from the repository
- the remaining H5 debt is now concentrated in `same_name_diff` behavior, not assembly structure
