# ARAM Shared Refactor Wave Report

Date: 2026-03-06
Wave: H5 Wave-N+4
Theme: Hazard / Juno / Orisa / Sigma diff localization

## Summary

This wave localized the next high-density hero-local ARAM diffs for `hazard/juno/orisa/sigma` from `src/aram_overrides.opy` into hero-owned `src/heroes/<hero>/aram*.opy` leaves.

The intent stayed the same as earlier H5 waves: keep `src/aram_overrides.opy` as a thinner assembly file, preserve ARAM ordering, and avoid balance or parameter changes.

## Changes

- Added `src/heroes/hazard/aram-05-spike-guard-suite.opy`
- Added `src/heroes/juno/aram-05-orbital-and-pulsar-heal.opy`
- Added `src/heroes/orisa/aram-05-fortify-armor.opy`
- Added `src/heroes/orisa/aram-10-control-suite.opy`
- Added `src/heroes/sigma/aram-05-hyperspheres-suite.opy`
- Replaced the corresponding inline rules in `src/aram_overrides.opy` with original-position hero-local includes

## Ordering / Contract Notes

- `src/aram_overrides.opy` still preserves original ARAM assembly order.
- `src/heroes/hazard/aram.opy`, `src/heroes/juno/aram.opy`, `src/heroes/orisa/aram.opy`, and `src/heroes/sigma/aram.opy` remain available as hero-local overlay entry points, while this wave uses `aram-*.opy` leaves to preserve separated insertion points.
- `[Juno]: Pulsar Torpedoes` intentionally remains inline in `src/aram_overrides.opy` because it is not part of the remaining `same_name_diff` batch.
- `soldier76` was removed from the "next dense same_name_diff wave" list because it is not present in the current `rule_same_name_diff` baseline.

## Metrics

- `src/aram_overrides.opy diff`: `40 -> 30`
- `src/heroes/*/aram*.opy diff`: `69 -> 79`
- `exact`: `0`
- `unwhitelisted aram/overlay exact-diff`: `0/0, 0/0`
- `build/reports/aram-delta-whitelist-candidates.tsv`: empty

## Validation

- `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero hazard --build`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero juno --build`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero orisa --build`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero sigma --build`

## Outcome

H5 remains `in_progress`, but the remaining debt in `src/aram_overrides.opy` is now visibly smaller and less concentrated. The next useful waves should target the remaining lower-density hero-local diffs before switching focus to system-level shared-vs-mode cleanup.
