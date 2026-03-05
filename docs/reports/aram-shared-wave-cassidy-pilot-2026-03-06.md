# ARAM Shared Refactor Wave-2 (Cassidy Pilot) - 2026-03-06

## Scope

- Pilot objective: remove 2 non-hero_init exact duplicates for Cassidy by reusing shared hero_rule leaves.
- Constraints: no gameplay tuning, no hero_init contract changes, no protocol index changes.

## Files Changed

1. Added shared Cassidy leaves:
   - `src/modules/hero_rules/shared/cassidy/10-flashbang-stun.opy`
   - `src/modules/hero_rules/shared/cassidy/30-alt-fire-reload.opy`
2. Replaced main Cassidy exact blocks with includes:
   - `src/modules/hero_rules/heroes/cassidy.opy`
3. Replaced ARAM override exact blocks with includes:
   - `src/aram_overrides.opy`
4. Whitelist close-out (remove 2 Cassidy exact entries):
   - `skills/ow-contract-guard/references/aram-delta-whitelist.tsv`
5. Tracking update:
   - `docs/aram-shared-refactor-todo.md`

## Duplicate Gate Metrics

### Before (baseline snapshot)

Command:
- `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv`

Result:
- total: `254`
- exact: `57`
- diff: `148`
- unique: `49`
- unwhitelisted exact/diff: `0/0`
- candidates: `0`

### After (this wave)

Command:
- `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv`

Result:
- total: `252`
- exact: `55`
- diff: `148`
- unique: `49`
- unwhitelisted exact/diff: `0/0`
- candidates: `0`

Delta:
- exact duplicate: `57 -> 55` (as expected)
- same-name-diff: unchanged (`148`)

## Validation

1. `pnpm run build`
   - PASS (existing warnings only)
2. `pnpm run build:aram`
   - PASS (existing warnings only)
3. `skills/ow-contract-guard/scripts/check_contracts.sh --build`
   - PASS (`397 passed, 0 warning(s), 0 failure(s)`)
4. `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init`
   - PASS (`396 passed, 0 warning(s), 0 failure(s)`)
5. `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff --build`
   - PASS for Cassidy
   - WARN: missing changelog branch for `Hero.CASSIDY` (existing warning policy)
6. `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero cassidy --build`
   - PASS for Cassidy
   - WARN: missing changelog branch for `Hero.CASSIDY`

## Behavior-Equivalence Check (Pilot Rules)

Checked that both shared leaf files are byte-equivalent to the rule blocks removed from previous `HEAD~1` versions of both main and ARAM files:

- `[Cassdy] Flashbang stun`: PASS
- `[Cassdy] Peacekeeper Alt Fire Reload`: PASS

Comparison source:
- previous `src/modules/hero_rules/heroes/cassidy.opy`
- previous `src/aram_overrides.opy`

## Conclusion

- Wave-2 Cassidy pilot completed successfully.
- Shared-leaf reuse path is validated for non-hero_init exact duplicates.
- Next candidate wave can reuse the same pattern for `Freja` or `Wuyang` exact duplicates.
