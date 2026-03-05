# ARAM vs Main Verification (2026-03-05)

## Scope
- Verify full diff between `src/aramMain.opy` (ARAM branch baseline) and `src/main.opy` modular mainline.
- Refactor ARAM to share verified common code without adding new files under `src/modules/*`.
- Keep ARAM behavior 1:1.

## Baseline Diff Summary
- Rules (unique names): `aram=355`, `main=372`, `common=313`, `aram-only=42`, `main-only=59`.
- Common rule bodies: `same=138`, `same-name-but-changed-body=175`.
- Settings hero delta:
  - `team1`: common heroes `33`, changed settings `32`, fully identical `1`.
  - `team2`: common heroes `35`, changed settings `34`, fully identical `1`.
- Protocol declarations:
  - `globalvar`: common `39`, index-changed `24`, aram-only `3`, main-only `2`.
  - `playervar`: common `58`, index-changed `10`, aram-only `10`, main-only `8`.
  - `subroutine`: common `13`, index-changed `1`, aram-only `2`, main-only `1`.

## Shared Whitelist (Fully Identical)
The following existing module files were verified as fully reusable and are shared by ARAM via include:
1. `src/modules/ai/00-delimiter-begin.opy`
2. `src/modules/ai/99-delimiter-end.opy`
3. `src/modules/hero_init/99-delimiter-end.opy`
4. `src/modules/hero_init/extras/echo-duplicate.opy`
5. `src/modules/hero_rules/heroes/echo.opy`
6. `src/modules/hero_rules/heroes/hanzo.opy`
7. `src/modules/hero_rules/heroes/lucio.opy`
8. `src/modules/hero_rules/heroes/mercy.opy`
9. `src/modules/hero_rules/heroes/vendetta.opy`

## Build Baseline Freeze
Commands used:
- `pnpm exec overpy compile -i src/main.opy --root src -o /tmp/main-pre-share.ow -l zh-CN`
- `pnpm exec overpy compile -i src/aramMain.opy --root src -o /tmp/aram-pre-share.ow -l zh-CN`

Notes:
- Mainline compiles with warnings only.
- ARAM had two `TeamLiteral` type mismatches; fixed with semantic-equivalent replacement:
  - `eventPlayer.getTeam() == __team__(Team.2)` -> `eventPlayer.getTeam() == Team.2`

## Refactor Output
New non-module files added:
- `src/aram_settings.opy`
- `src/aram_protocol.opy`
- `src/aram_shared_index.opy`
- `src/aram_overrides.opy`

`src/aramMain.opy` converted to thin entry:
- constants -> aram_settings -> aram_protocol -> optimizeStrict/postHook -> aram_shared_index -> aram_overrides

## 1:1 Fidelity Check
Compiled outputs:
- pre-share: `/tmp/aram-pre-share.ow`
- post-share: `/tmp/aram-post-share.ow`

Verification result:
- Byte hash differs (expected due include composition order changes and rule emission order):
  - `pre_sha256=c6096f31ef10a6b339a971434bc4590d35382b3ae394e1640e0fbd31940b53c1`
  - `post_sha256=873a6a10bccb218cc54de6e29b5e8931ce703a19e8d44cdc598d952fc3961305`
- Rule-block multiset comparison: **identical**.
  - `pre_rule_blocks=392`
  - `post_rule_blocks=392`
  - `equal_multiset=True`
  - `only_pre=0`, `only_post=0`
- Declaration/header segment comparison (ignoring strict optimize comment duplication): **identical**.

Conclusion:
- ARAM refactor preserves rule content and declaration content 1:1 while sharing verified module code.

## Gate Status
- `skills/ow-contract-guard/scripts/check_contracts.sh`: passed for mainline contracts.
- `pnpm run build`: passed (warnings only), output `workshop.ow`.
- `pnpm run build:aram`: passed (warnings only), output `build/aram.ow`.

## Follow-up (2026-03-05): P0 Shared Utilities Extraction

Implemented low-risk extraction for fully identical utility defs:
- Added `src/aram_shared_utilities.opy` and included:
  - `utilities/bot_aim2target.opy`
  - `utilities/enable_all_abilities.opy`
  - `utilities/reset_frenemies.opy`
- Updated `src/aramMain.opy` include flow:
  - `... -> aram_shared_index -> aram_shared_utilities -> aram_overrides`
- Removed duplicate defs from `src/aram_overrides.opy`:
  - `botAim2Target`
  - `enableAllAbilities`
  - `resetFrenemies`

Validation:
- `pnpm run build`: passed (warnings only).
- `pnpm run build:aram`: passed (warnings only).
- `skills/ow-contract-guard/scripts/check_contracts.sh --build`: passed.
- `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init`: passed.

## Follow-up (2026-03-05): T3 Reset Toolchain Parameterization

Implemented shared skeleton + ARAM profile parameterization for reset utility chain:
- Added reset behavior profile macros in `src/aram_protocol.opy` (ARAM profile).
- Added mainline profile macro defaults in `src/modules/bootstrap/20-player-lifecycle-and-reset.opy` (after `clearMoveSpeedDebuffs()`).
- Refactored shared utilities to consume profile macros:
  - `utilities/disable_all_abilities.opy`
  - `utilities/reset_stats.opy`
  - `utilities/reset_statuses.opy`
  - `utilities/reset_hero.opy`
  - `utilities/remove_tank_passive.opy`
- Expanded `src/aram_shared_utilities.opy` include list with the 5 reset-related utilities above.
- Removed duplicated ARAM defs from `src/aram_overrides.opy`:
  - `disableAllAbilities`
  - `resetStats`
  - `resetStatuses`
  - `resetHero`
  - `removeTankPassive`

Validation:
- `pnpm run build`: passed (warnings only).
- `pnpm run build:aram`: passed (warnings only).
- `skills/ow-contract-guard/scripts/check_contracts.sh --build`: passed.
- `skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init`: passed.
