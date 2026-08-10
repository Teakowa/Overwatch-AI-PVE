# Ana Biotic Grenade portability boundary

`src/heroes/ana/ability2.opy` is the reference portability fragment for the
ownership refactor. The reproducible check is:

```bash
pnpm run tool:check-ana-portability
```

The check validates the source boundary and compiles a temporary minimal fixture
containing only:

- the Ana Biotic Grenade rule;
- `modules/combat-policy/custom-effect-guards.opy`;
- the two constants used by the rule;
- `Ana_GrenadeDamage`, `has_nano`, and `zarya_buff` declarations required by
  the fragment and its policy.

The fixture does not include either prelude registry. This proves that the rule
does not need to copy the full project-wide `global-vars.opy` or
`player-vars.opy` files.

## Minimum dependency set

For a Main/ARAM reuse, provide the following narrow boundary:

| Responsibility | Source in this project | Reuse requirement |
| --- | --- | --- |
| Biotic Grenade rule | `src/heroes/ana/ability2.opy` | Copy the rule and retain its event, status, and damage conditions. |
| Ana setting | `src/heroes/ana/settings.opy` or `settings.aram.opy` | Provide `Ana_GrenadeDamage`; the Workshop setting values and IDs are mode-specific. |
| Protection policy | `src/modules/combat-policy/custom-effect-guards.opy` | Provide `Player.blocksCustomDot()` or an equivalent semantic policy. The rule does not read `zarya_buff` directly. |
| Balance constants | `src/constants/hero_balance_constants.opy` | Provide `ANA_ABILITY2_BURNING_DURATION` and `ANA_ABILITY2_DOT_DURATION`, or equivalent values. |
| Engine/runtime surface | Overwatch Workshop built-ins | Provide `Hero.ANA`, `Button.ABILITY_2`, `Status.BURNING`, player events, and the referenced Player methods. |

`Status.BURNING` is an explicit Workshop status dependency. The retired `burn_stack`
state and its unused owner module have been removed; that state must not be recreated
merely because the effect is burning.

## Intentionally project-specific

- `#!mainFile` paths and the Main/ARAM include graph.
- Workshop setting labels, localization, and IDs (`104`/`105`).
- The exact `zarya_buff[1]` storage layout behind the combat policy.
- The shared `has_nano` player-state layout and any reset/lifecycle policy.
- Ana's other settings and Nano Boost rules. They are not required by the
  Biotic Grenade fragment.

The static checks intentionally keep the invincible/phased-out and Nano gates
separate from the custom-DOT policy. A future portability change must update the
semantic boundary and its fixture together.
