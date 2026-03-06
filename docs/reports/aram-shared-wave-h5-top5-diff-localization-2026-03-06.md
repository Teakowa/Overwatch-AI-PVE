# ARAM Shared Refactor H5 Wave-N+1 (Top-5 Same-Name Diff Localization) - 2026-03-06

## Summary

- Wave: H5 Wave-N+1
- Objective: move the top-5 hero-local `same_name_diff` rule bodies out of `src/aram_overrides.opy` and into hero-owned `aram*.opy` overlays.
- Scope:
  - `ramattra / sombra / tracer / zarya / wrecking_ball`
  - 16 existing `rule_same_name_diff`
- Non-goals:
  - reduce `same_name_diff` count
  - rebalance gameplay values
  - convert diff rules into shared exact leaves

## Implemented Changes

- Replaced 16 inline ARAM diff rule bodies in `src/aram_overrides.opy` with original-position hero-local includes.
- Added ARAM leaf files for heroes with split placement requirements:
  - `ramattra`: `aram-10-ult-suite.opy`, `aram-20-block-suite.opy`
  - `tracer`: `aram-10-instant-respawn.opy`, `aram-20-pulse-bomb-damage.opy`
  - `zarya`: `aram-10-projected-barrier-shields.opy`, `aram-20-will-to-win.opy`
- Expanded existing thin overlays:
  - `src/heroes/sombra/aram.opy`
  - `src/heroes/wrecking_ball/aram.opy`
- Left Main ownership unchanged in `src/heroes/<hero>/rules*.opy`.

## Expected Duplicate Profile

- `src/aram_overrides.opy diff: 106 -> 90`
- `src/heroes/*/aram*.opy diff: 2 -> 18`
- `exact = 0`
- `unwhitelisted aram/overlay exact-diff = 0/0, 0/0`
- candidate whitelist rows remain empty

## Notes

- This wave is diff localization, not diff elimination.
- `Ramattra` keeps the current duplicated rule name `[Ramattra]: block` for the ARAM-only HP conversion rule to avoid name churn during localization.
- `Tracer` and `Zarya` use multiple `aram-*.opy` leaves because their ARAM diff rules are still assembled in separated positions.

## Acceptance

Wave-N+1 is complete when:

- the 16 targeted rules are no longer inlined in `src/aram_overrides.opy`
- build, contract guard, hero pipeline, and duplicates checks all pass
- worktree diff only reflects localization plus doc/report updates
