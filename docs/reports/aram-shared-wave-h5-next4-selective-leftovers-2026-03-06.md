# ARAM Shared Refactor Wave Report

Date: 2026-03-06
Wave: H5 Wave-N+6
Theme: Selective hero-local leftovers and report cleanup

## Summary

This wave localized the remaining safe hero-local `same_name_diff` rules for `cassidy/genji/venture/zenyatta` from `src/aram_overrides.opy` into hero-owned `aram*.opy` leaves.

It also removed two early pilot reports that were no longer referenced and had been fully superseded by later H4/H5 reports.

## Changes

- Added `src/heroes/cassidy/aram-05-alt-fire.opy`
- Added `src/heroes/cassidy/aram-10-falloff.opy`
- Expanded `src/heroes/genji/aram.opy`
- Expanded `src/heroes/venture/aram.opy`
- Added `src/heroes/zenyatta/aram-05-headshot-damage.opy`
- Added `src/heroes/zenyatta/aram-10-snap-kick-enemy.opy`
- Added `src/heroes/zenyatta/aram-20-transcendence.opy`
- Replaced the corresponding inline rules in `src/aram_overrides.opy` with original-position includes
- Deleted `docs/reports/aram-shared-wave-cassidy-pilot-2026-03-06.md`
- Deleted `docs/reports/aram-shared-wave-freja-pilot-2026-03-06.md`

## Ordering / Contract Notes

- `cassidy` and `zenyatta` were split into multiple `aram-*.opy` leaves to preserve separated insertion points in `src/aram_overrides.opy`.
- `genji` and `venture` each used a single hero-local `aram.opy` include because their remaining diffs were single-point insertions.
- System/bootstrap diffs were intentionally left untouched in this wave to avoid crossing into unrelated in-progress local changes.

## Metrics

- `src/aram_overrides.opy diff`: `18 -> 12`
- `src/heroes/*/aram*.opy diff`: `91 -> 98`
- `exact`: `0`
- `unwhitelisted aram/overlay exact-diff`: `0/0, 0/0`
- `build/reports/aram-delta-whitelist-candidates.tsv`: empty

## Validation

- `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero cassidy --build`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero genji --build`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero venture --build`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero zenyatta --build`

## Outcome

After this wave, `src/aram_overrides.opy` is down to 12 remaining `same_name_diff` rules. What remains is mostly system-level debt plus a small number of selective leftovers, which is a much cleaner end-state for finishing H5.
