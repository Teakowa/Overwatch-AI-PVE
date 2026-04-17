---
name: ow-contract-guard
description: Validate Overwatch-AI-PVE Workshop contract invariants before and after gameplay edits. Use when modifying src/main.opy, src/modules/*, hero init/rules, variable or subroutine indices, include order, delimiter rules, or reset_pvar slot mappings.
---

# OW Contract Guard

Run contract checks before committing gameplay or structural changes.

## Quick Start

Run the default contract check:

```bash
skills/ow-contract-guard/scripts/check_contracts.sh
```

Run with build gate:

```bash
skills/ow-contract-guard/scripts/check_contracts.sh --build
```

Run strict hero-init gating check:

```bash
skills/ow-contract-guard/scripts/check_contracts.sh --strict-hero-init
```

## Enforced Contracts

The checker validates these invariants:

1. `src/main.opy` 扁平 include 顺序：
   - `constants/player_constants.opy`
   - `modules/prelude/settings.opy -> global-vars.opy -> player-vars.opy -> subroutine-names.opy`
   - `#!optimizeStrict`
   - `modules/bootstrap/* -> utilities/* -> modules/ai/* -> modules/hero_rules/* -> modules/hero_init/* -> modules/debug/*`
   - `src/main.opy` 不直接 include `*_index.opy`。
2. Delimiter include boundaries in `ai/_index.opy` and `hero_init/_index.opy`.
3. Required delimiter rule names exist exactly once:
   - `Initialize AI Scripts`
   - `Initialize AI Scripts End`
   - `Initialize Heroes`
   - `Initialize Heors End`
4. Protocol index mappings for `globalvar`, `playervar`, `subroutine` (against `references/protocol-indexes.tsv`).
5. Stable `reset_pvar` slot assignments in `bootstrap/player-lifecycle-and-reset.opy`.
6. Hero init safety pattern checks in `hero_init/heroes/*.opy`:
   - Detect trigger sets `reset_pvar[0] = true`
   - Initialize path calls `resetHero()`
   - Initialize path resets `reset_pvar[0] = false`
   - Initialize condition on `reset_pvar[0]` (warning by default, error in strict mode)

## Expected Behavior

- Treat `[FAIL]` as a blocking issue.
- Treat `[WARN]` as technical debt to schedule or clean up.
- Keep checks green before commit when touching structure, reset chain, or hero init.

## Related Policy Gate

For hero gameplay edits, enforce cooldown placement policy together with this guard:

- Generic cooldown tuning belongs in `src/modules/prelude/settings.opy`.
- `hero_rules` should only modify cooldowns when effects are trigger-dependent (for example hit-confirm refund, elimination refund, conditional lockout).
- Run:

```bash
skills/ow-hero-change-pipeline/scripts/hero_pipeline.sh --from-diff --strict-cooldown-placement
```

## Updating Index Baseline

Only update `references/protocol-indexes.tsv` when intentionally adding new declarations or intentionally changing protocol mappings.

After intentional protocol updates, regenerate the baseline from source files:

```bash
{
  awk '/^globalvar /{print "globalvar\t"$2"\t"$3}' src/modules/prelude/global-vars.opy
  awk '/^playervar /{print "playervar\t"$2"\t"$3}' src/modules/prelude/player-vars.opy
  awk '/^subroutine /{print "subroutine\t"$2"\t"$3}' src/modules/prelude/subroutine-names.opy
} > skills/ow-contract-guard/references/protocol-indexes.tsv
```

Then rerun:

```bash
skills/ow-contract-guard/scripts/check_contracts.sh --build
```
