# ARAM Shared Refactor H5 Wave-N+2 (Next-4 Same-Name Diff Localization) - 2026-03-06

## Summary

- Wave: H5 Wave-N+2
- Objective: move the next four highest-density hero-local `same_name_diff` rule groups out of `src/aram_overrides.opy` and into hero-owned `aram*.opy` overlays.
- Scope:
  - `doomfist / mauga / reaper / wuyang`
  - 26 existing `rule_same_name_diff`
- Non-goals:
  - reduce `same_name_diff` count
  - rebalance gameplay values
  - convert diff rules into shared exact leaves

## Implemented Changes

- Replaced 26 inline ARAM diff rule bodies in `src/aram_overrides.opy` with original-position hero-local includes.
- Added split overlay leaves where the ARAM assembly order still requires multiple include points:
  - `src/heroes/doomfist/aram-10-combat-suite.opy`
  - `src/heroes/mauga/aram-10-frontline-suite.opy`
- Expanded existing overlays:
  - `src/heroes/doomfist/aram.opy`
  - `src/heroes/mauga/aram.opy`
  - `src/heroes/reaper/aram.opy`
  - `src/heroes/wuyang/aram.opy`
- Left Main ownership unchanged in `src/heroes/<hero>/rules*.opy`.

## Expected Duplicate Profile

- `src/aram_overrides.opy diff: 90 -> 64`
- `src/heroes/*/aram*.opy diff: 18 -> 45`
- `exact = 0`
- `unwhitelisted aram/overlay exact-diff = 0/0, 0/0`
- candidate whitelist rows remain empty

## Notes

- This wave is diff localization, not diff elimination.
- `doomfist` and `mauga` keep split ARAM leaves because their diff rules still occupy separated positions in the ARAM assembly.
- `reaper` and `wuyang` reuse their existing `aram.opy` entrypoints because the remaining diff rules were already contiguous behind those include points.
