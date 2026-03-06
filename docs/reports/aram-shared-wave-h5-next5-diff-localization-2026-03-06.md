# ARAM Shared Refactor Wave Report

Date: 2026-03-06
Wave: H5 Wave-N+3
Theme: Next-5 same_name_diff localization

## Summary

This wave localized 24 `rule_same_name_diff` entries for `ana/brigitte/freja/kiriko/reinhardt` from `src/aram_overrides.opy` into hero-owned `src/heroes/<hero>/aram*.opy` files.

The goal of this wave was not to eliminate mode diffs. The goal was to keep shrinking `src/aram_overrides.opy` into a thinner assembly surface while preserving exact ARAM ordering and behavior.

## Changes

- Added `src/heroes/ana/aram-05-headhunter.opy`
- Added `src/heroes/ana/aram-10-sleep-tanks.opy`
- Expanded `src/heroes/ana/aram.opy` for `Has Nano` and `[Ana] Nano Boost Healing`
- Added `src/heroes/brigitte/aram-05-rally-and-slam.opy`
- Expanded `src/heroes/brigitte/aram.opy` for Rally speed boost
- Expanded `src/heroes/freja/aram.opy` to own 5 Freja ARAM diffs
- Added `src/heroes/kiriko/aram-05-support-suite.opy`
- Added `src/heroes/kiriko/aram-10-headshot-damage.opy`
- Added `src/heroes/reinhardt/aram-05-combat-suite.opy`
- Expanded `src/aram_overrides.opy` to replace 24 inline rules with original-position hero-local includes

## Ordering / Contract Notes

- `src/aram_overrides.opy` remains an assembly layer only for this wave; no rule reordering was introduced.
- `same_name_diff` rules now live in hero-local overlay files, but their source-of-truth Main rules remain in `src/heroes/<hero>/rules*.opy`.
- `[Ana] Biotic Grenade Hit for allies` and the two `[Ana] Nano Boost` ARAM-only rules intentionally remain inline because they are not part of this localization batch.

## Metrics

- `src/aram_overrides.opy diff`: `64 -> 40`
- `src/heroes/*/aram*.opy diff`: `45 -> 69`
- `exact`: `0`
- `unwhitelisted aram/overlay exact-diff`: `0/0, 0/0`
- `build/reports/aram-delta-whitelist-candidates.tsv`: empty

## Validation

- `pnpm run build`
- `pnpm run build:aram`
- `skills/ow-contract-guard/scripts/check_contracts.sh --build`
- `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero ana --build`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero brigitte --build`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero freja --build`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero kiriko --build`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero reinhardt --build`
- `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv`

## Outcome

H5 remains `in_progress`, but `src/aram_overrides.opy` is materially thinner and the remaining debt is more clearly hero-local. The next wave should continue with the highest-density hero-local diff groups still left inline in the ARAM assembly file.
