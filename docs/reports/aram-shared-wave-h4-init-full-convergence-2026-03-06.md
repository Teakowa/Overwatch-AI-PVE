# ARAM Shared Refactor H4 Wave-2 (Full Initialize Convergence) - 2026-03-06

## Scope

- Wave: H4 Wave-2
- Objective: converge ARAM hero `Initialize` to Main implementation in one pass.
- Policy:
  - full scope (`all-at-once`)
  - byte-level alignment to Main hero init
  - remove ARAM-local `custom_hp` helper chain
  - keep Ramattra non-init gating by max-health-derived threshold

## Files Changed

- Runtime wiring:
  - `src/aram_overrides.opy`
  - `src/aramMain.opy`
  - `src/aram_protocol.opy`
  - `src/aram_overrides_segments/hero_init_widowmaker_falloff_and_bastion_detect.opy`
  - `src/aram_overrides_segments/manifest.tsv`
- Governance/docs:
  - `skills/ow-contract-guard/references/aram-delta-whitelist.tsv`
  - `docs/aram-shared-refactor-todo.md`

## Key Changes

- `aram_overrides` hero_init section now reuses Main-order includes:
  - `#!include "heroes/<hero>/init.opy"` for all heroes in `src/heroes/main.opy` init order.
- Removed ARAM inline Detect/Initialize blocks from `aram_overrides`.
- Removed ARAM-local `def clearCustomHp()` and `def applyCustomHp()` from `aram_overrides`.
- Added utilities includes in `aramMain`:
  - `utilities/apply_custom_hp.opy`
  - `utilities/clear_custom_hp.opy`
- Replaced Ramattra 4 conditions:
  - from `eventPlayer.custom_hp_pvar[0] + 50`
  - to `eventPlayer.getMaxHealthOfType(Health.NORMAL) + 50`
- Removed Bastion Detect residual from segmented file and synced manifest metadata.
- Cleared all whitelist rows whose `source_module` was `src/heroes/*/init.opy`.

## Validation Results

1. `pnpm run build` -> PASS
2. `pnpm run build:aram` -> PASS
3. `skills/ow-contract-guard/scripts/check_contracts.sh --build` -> PASS
4. `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init` -> PASS
5. `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff --build` -> PASS (`No hero-related file changes detected from diff range: HEAD`)
6. `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv` -> PASS

## Duplicate Metrics

- `total: 164`
- `exact: 11`
- `diff: 106`
- `unique: 47`
- `unwhitelisted exact/diff: 0/0`
- `candidates: 0`

## Conclusion

Wave-2 completed the intended convergence target:

- ARAM hero initialization now reuses Main hero init modules directly.
- ARAM-local `custom_hp` helper chain is removed from `aram_overrides`.
- Duplicate baseline dropped significantly while whitelist cleanliness remains intact.
