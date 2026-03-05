# ARAM Shared Refactor Wave-3 (Freja Pilot) - 2026-03-06

## Scope

- Hero: `Freja`
- Change type: extract non-hero_init exact duplicates from `aram_overrides.opy` into shared hero_rules leaves.
- Out of scope: hero_init changes, same-name-diff convergence.

## Files Changed

- `src/modules/hero_rules/shared/freja/10-revdraw-crossbow-stack-primary-fire.opy` (new)
- `src/modules/hero_rules/shared/freja/90-set-projectile-speed.opy` (new)
- `src/modules/hero_rules/heroes/freja.opy`
- `src/aram_overrides.opy`
- `skills/ow-contract-guard/references/aram-delta-whitelist.tsv`
- `docs/aram-shared-refactor-todo.md`

## Metric Delta

- Baseline: `total=252, exact=55, diff=148, unique=49, unwhitelisted exact/diff=0/0`
- After Wave-3: `total=250, exact=53, diff=148, unique=49, unwhitelisted exact/diff=0/0`
- Candidates rows: `0`

## Validation Results

- `pnpm run build`: PASS (existing warnings only)
- `pnpm run build:aram`: PASS (existing warnings only)
- `skills/ow-contract-guard/scripts/check_contracts.sh --build`: PASS
- `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init`: PASS
- `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check --emit-candidates ...`: PASS (`exact=53`, `diff=148`, candidates=0)
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff --build`: PASS for `freja` (warning: missing changelog branch for `Hero.FREJA`)

## Behavior Equivalence Check (Pilot-Specific)

Compiled output checks:

- PASS: `workshop.ow` and `build/aram.ow` first `"[Freja]: Revdraw Crossbow Stack"` rule blocks are text-equivalent.
- PASS: `workshop.ow` and `build/aram.ow` `"[Freja]: set Projectile speed"` rule blocks are text-equivalent.
- PASS: ARAM second `"[Freja]: Revdraw Crossbow Stack"` still retains `+40` delta logic.

## Conclusion

Wave-3 Freja pilot meets acceptance criteria:

- Exact duplicates reduced by 2 (`55 -> 53`)
- Same-name-diff unchanged (`148`)
- No unwhitelisted deltas introduced
- No hero_init/reset-chain regressions detected
