# player-vars hero split todo

## Summary

This file tracks the remaining hero-related variables in `src/modules/prelude/player-vars.opy`
and groups them by whether they are good split candidates.

Recommended next batch:

- `ram_block_damage`
- `ram_block_damage_hud`
- `reaper_buff`
- `sigma_hyperspheres`
- `sigma_hyperspheres_hud`
- `doom_buff`
- `doom_buff_hud`
- `freja_buff`

## 1. Recommended next batch

| Variable | Current reach | Recommended action | Expected landing area | Notes |
| --- | --- | --- | --- | --- |
| `ram_block_damage` | `ramattra` + `reset_hero` | Split next | `ramattra` init/skill side | Single-hero state, extra reach is only reset chain |
| `ram_block_damage_hud` | `ramattra` + `reset_hero` | Split next | Same as above | Keep with `ram_block_damage` |
| `reaper_buff` | `reaper` + `reset_hero` | Split next | `reaper` implementation side | Typical single-hero buff state |
| `sigma_hyperspheres` | `sigma` + lifecycle/reset | Split next | `sigma` implementation side | Needs matching reset migration |
| `sigma_hyperspheres_hud` | `sigma` + `reset_hero` | Split next | Same as above | Keep with `sigma_hyperspheres` |
| `doom_buff` | `doomfist` + lifecycle/reset | Split next | `doomfist` implementation side | Single-hero state |
| `doom_buff_hud` | `doomfist` + `reset_hero` | Split next | Same as above | Keep with `doom_buff` |
| `freja_buff` | `freja` + `reset_statuses` | Split next | `freja` implementation side | Extra reach is only reset chain |

## 2. Candidate but defer for now

| Variable | Current reach | Current recommendation | Reason |
| --- | --- | --- | --- |
| `third_person` | `soldier76` + `aram_protocol`/`set_third_person` | Defer | Crosses protocol/mode boundary |
| `taunt` | `junker_queen` + `main_mode_profile` | Defer | Tied to mode profile logic |
| `KnockbackDirection` | `zenyatta` + `utilities/knockback` | Defer | Consumed by a shared utility |
| `wuyang_buff` | `wuyang` + lifecycle | Defer | Need to confirm lifecycle ownership first |
| `hazard_using_ability_sec` | `hazard` + `ai/core` | Defer | AI reads it directly |

## 3. Keep in prelude

| Variable or group | Recommendation | Reason |
| --- | --- | --- |
| `reset_pvar`, `heroNum`, `hudText`, `unaffected` | Keep in prelude | Shared player state |
| `botTemp`, `botTarget`, `Strafe`, `heros`, `extra_hero` | Keep in prelude | Infra or generic player state |
| `mov_speed_penalty`, `mov_speed_buff`, `orisa_buff`, `mauga_berserker_soul`, `brigitte_buff`, `zarya_graviton_buff`, `zarya_buff`, `heart_steel`, `has_nano`, `dmg_amplification`, `dmg_reduction` | Keep in prelude | Shared mechanic or multi-hero state |
| `hazard_buff` | Keep in prelude | Multi-hero mixed usage |
| `scoped_shot_distance`, `scoped_damage_base`, `ow2_scoped_damage_falloff_scalar`, `ow1_scoped_damage_falloff_scalar`, `expected_scoped_damage` | Keep in prelude | Shared scoped-damage mechanism |
| `burn_stack` | Keep in prelude | Multi-hero shared state |
| `ChangelogText1`, `ChangelogText2`, `ChangelogSubtext`, `ChangelogBody`, `aram_extra_pool_applied` | Keep in prelude | Non-hero-private state |

## 4. Migration notes for the recommended batch

- Every touched local declaration file should carry explicit `#!mainFile`.
- Reset/lifecycle files that still reference migrated variables also need explicit `#!mainFile`.
- Prefer moving declarations close to the owning hero implementation rather than creating a new shared bucket.
- Migrate grouped variables together when they represent one mechanic or one HUD pair.
