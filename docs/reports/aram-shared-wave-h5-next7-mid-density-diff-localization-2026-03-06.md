# ARAM Shared Refactor Wave Report

Date: 2026-03-06
Wave: H5 Wave-N+5
Theme: Remaining mid-density hero-local diff localization

## Summary

This wave localized the remaining mid-density hero-local `same_name_diff` rules for `ashe/baptiste/illari/junkrat/moira/roadhog/sojourn` from `src/aram_overrides.opy` into hero-owned `src/heroes/<hero>/aram.opy`.

The goal remained the same: reduce the central ARAM assembly surface without changing behavior, rule ordering, or balance values.

## Changes

- Expanded `src/heroes/ashe/aram.opy` for headshot damage
- Expanded `src/heroes/baptiste/aram.opy` for headshot damage and Immortality Field
- Expanded `src/heroes/illari/aram.opy` for Captive Sun HUD and damage
- Expanded `src/heroes/junkrat/aram.opy` for arsonist
- Expanded `src/heroes/moira/aram.opy` for Fade disable on Coalescence
- Expanded `src/heroes/roadhog/aram.opy` for the 3 Breather diffs
- Expanded `src/heroes/sojourn/aram.opy` for Overclock Buff and execution
- Replaced the corresponding inline rules in `src/aram_overrides.opy` with original-position hero-local includes

## Ordering / Contract Notes

- `src/aram_overrides.opy` still preserves original assembly order.
- This wave intentionally touched only whitelist-backed `rule_same_name_diff` entries for these heroes.
- Non-diff ARAM-only rules such as `Roadhog` hook rules, `Junkrat` trap bleed, and `Juno` secondary-fire damage remain inline on purpose.

## Metrics

- `src/aram_overrides.opy diff`: `30 -> 18`
- `src/heroes/*/aram*.opy diff`: `79 -> 91`
- `exact`: `0`
- `unwhitelisted aram/overlay exact-diff`: `0/0, 0/0`
- `build/reports/aram-delta-whitelist-candidates.tsv`: empty

## Validation

- `skills/ow-contract-guard/scripts/check_aram_overrides_duplicates.sh --check --emit-candidates build/reports/aram-delta-whitelist-candidates.tsv`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero ashe --build`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero baptiste --build`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero illari --build`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero junkrat --build`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero moira --build`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero roadhog --build`
- `skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --hero sojourn --build`

## Outcome

After this wave, `src/aram_overrides.opy` is down to 18 remaining `same_name_diff` rules. The remaining work is no longer concentrated in a few dense hero groups, which makes the next H5 steps more selective and likely to mix hero-local leftovers with system-level cleanup.
