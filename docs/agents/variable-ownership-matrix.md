# Prelude Variable Ownership Matrix

This is the canonical audit for issue #69. It covers every declaration that remains
in src/modules/prelude/global-vars.opy or src/modules/prelude/player-vars.opy after
the Ana settings pilot (#65), the Domina audit (#68), the retired burn-stack owner
(#66), the Ana combat-policy pilot (#67), and the completed #70 settings waves.

The matrix is an audit and migration plan. It does not itself authorize a bulk move.
Each future wave must preserve the declaration name, Main and ARAM reach, and the
reset/lifecycle behavior recorded here.

## Reading the matrix

- M+A means the declaration is currently reachable from both src/main.opy and
  src/aramMain.opy through the shared prelude includes. Consumer paths marked M or A
  are mode-specific; an unmarked path is shared or is present in both graphs.
- settings.opy is a shared hero settings module when ARAM includes that file.
  settings.aram.opy is listed explicitly when ARAM has a mode-specific settings
  module.
- changelog_text.opy is a display consumer of many hero settings. It does not own
  those settings; the settings wave must retain an explicit dependency or replace
  this generic read.
- reset means reset_hero.opy, reset_stats.opy, or a lifecycle/reset module. The
  reset path is included in the consumer cell when it is material to ownership.
- Current owner paths are relative to the repository root.

## Global declarations

### keep: infrastructure/shared protocol

| Variable | Kind | Current owner | Consumers | Main/ARAM | Target owner | Action | Blocker |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Mark | globalvar | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, debug/changelog.opy | M+A | prelude/global-vars.opy | K-1 keep public mode metadata | none |
| Collaborator | globalvar | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, bootstrap/safety-blacklist-ban.opy | M+A | prelude/global-vars.opy | K-1 keep public mode metadata | none |
| ANTI_CRASH_ACTIVATE_PERCENT | globalvar | prelude/global-vars.opy | no active consumer outside prelude | M+A | prelude/global-vars.opy | K-2 retain reserved anti-crash ABI until a removal audit | no active reader found |
| ANTI_CRASH_HOLD_TIME | globalvar | prelude/global-vars.opy | no active consumer outside prelude | M+A | prelude/global-vars.opy | K-2 retain reserved anti-crash ABI until a removal audit | no active reader found |
| ANTI_CRASH_DEACTIVATE_PERCENT | globalvar | prelude/global-vars.opy | no active consumer outside prelude | M+A | prelude/global-vars.opy | K-2 retain reserved anti-crash ABI until a removal audit | no active reader found |
| Debug_UltimateGain | globalvar | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, debug/debug-ultimate.opy | M+A | prelude/global-vars.opy | K-1 keep debug infrastructure state | none |
| FalloffMin | globalvar | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, ai/movement/movement.opy | M+A | prelude/global-vars.opy | K-1 keep shared AI movement data | AI movement consumes the array directly |
| ProjectileSpeed | globalvar | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, ai/control/ana.opy, ai/control/kiriko.opy | M+A | prelude/global-vars.opy | K-1 keep shared hero/AI projectile data | AI and settings consumers share the data |
| BotHeroArray | globalvar | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, heroes/ana/init.opy, heroes/anran/init.opy | M+A | prelude/global-vars.opy | K-1 keep bot roster infrastructure | none |
| Heros | globalvar | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, bootstrap/safety-blacklist-ban.opy, bootstrap/aram-safety-blacklist-ban.opy, ai/core/core-global-and-targeting.opy | M+A | prelude/global-vars.opy | K-1 keep roster/protocol state | none |
| Hero_BAN | globalvar | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, bootstrap/safety-blacklist-ban.opy, bootstrap/aram-safety-blacklist-ban.opy, bootstrap/aram-extra-hero-pool.opy | M+A | prelude/global-vars.opy | K-1 keep mode selection state | none |
| Counters | globalvar | prelude/global-vars.opy | ai/core/core-global-and-targeting.opy | M+A | prelude/global-vars.opy | K-1 keep AI counter protocol | none |
| Counter_Bot | globalvar | prelude/global-vars.opy | ai/core/core-global-and-targeting.opy | M+A | prelude/global-vars.opy | K-1 keep AI counter protocol | none |
| Blacklist | globalvar | prelude/global-vars.opy | bootstrap/blacklist.opy | M+A | prelude/global-vars.opy | K-1 keep safety infrastructure | none |
| CustomAI | globalvar | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, ai/core/core-global-and-targeting.opy | M+A | prelude/global-vars.opy | K-1 keep AI mode configuration | none |
| CustomAIArray | globalvar | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, ai/core/core-global-and-targeting.opy, ai/control/common.opy | M+A | prelude/global-vars.opy | K-1 keep AI roster configuration | none |
| ChangelogHeroes | globalvar | prelude/global-vars.opy | debug/changelog.opy, utilities/changelog_text.opy | M+A | prelude/global-vars.opy | K-1 keep changelog table protocol | none |
| ChangelogBodyTable | globalvar | prelude/global-vars.opy | debug/changelog.opy, utilities/changelog_text.opy | M+A | prelude/global-vars.opy | K-1 keep changelog table protocol | none |

### move: hero-owned global state/settings

No unambiguous hero-owned global settings remain after the #70 migration waves.
The remaining global declarations are explicitly classified under keep or defer.

### defer: cross-module coupling must be resolved first

| Variable | Kind | Current owner | Consumers | Main/ARAM | Target owner | Action | Blocker |
| --- | --- | --- | --- | --- | --- | --- | --- |
| MoiraBuff | globalvar | prelude/global-vars.opy | aram_protocol.opy, heroes/moira/settings.opy, settings.aram.opy, rules.opy, aram.opy; utilities/changelog_text.opy | M+A | future mode-settings/aram-protocol boundary or an explicit Moira settings API | D-MOIRA defer until ARAM protocol no longer reads a hero-owned setting before hero settings are included | aram_protocol.opy reads MoiraBuff before heroes/moira/settings.aram.opy is included |
| BaptisteBuff | globalvar | prelude/global-vars.opy | heroes/baptiste/settings.opy, rules.opy; utilities/changelog_text.opy; ARAM uses HeadshotDamage instead | M+A | future mode-settings/changelog API or a shared Baptiste settings boundary | D-BAPTISTE defer until the ARAM changelog no longer reads a Main-only Baptiste setting | heroes/baptiste/settings.aram.opy does not define BaptisteBuff, but shared changelog_text.opy reads it in ARAM |
| HanzoBuff | globalvar | prelude/global-vars.opy | heroes/hanzo/settings.opy, rules.opy; heroes/hanzo/settings.aram.opy uses HeadshotDamage; utilities/changelog_text.opy | M+A | future mode-settings/changelog API or a shared Hanzo settings boundary | D-HANZO defer until ARAM changelog and Hanzo mode settings share a named interface | heroes/hanzo/settings.aram.opy does not define HanzoBuff, but shared changelog_text.opy reads it in ARAM |
| HeadshotDamage | globalvar | prelude/global-vars.opy | heroes/ashe/rules.opy, hanzo/aram.opy, baptiste/aram.opy, kiriko/headshot.opy, zenyatta/rules.opy, zenyatta/aram.opy; utilities/changelog_text.opy | M+A | future modules/combat-policy/headshot-settings.opy or explicit hero settings API | D-HEADSHOT defer until the headshot policy is named and its readers use it | five hero consumers read one shared array |
| SojournBuff | globalvar | prelude/global-vars.opy | heroes/sojourn/settings.opy, ultimate.opy, aram.opy; heroes/genji/aram.opy; utilities/changelog_text.opy | M+A | heroes/sojourn/settings.opy plus a semantic Genji execution input | D-SOJOURN defer until the cross-hero Genji read is removed | Genji directly consumes Sojourn storage |
| Zen_KnockupStrength | globalvar | prelude/global-vars.opy | utilities/knockback.opy; heroes/zenyatta/settings.opy | M+A | future modules/knockback/state.opy | D-KNOCKBACK defer until Knockback exposes a semantic strength interface | utility and hero directly share the setting |

## Player declarations

### keep: infrastructure/shared protocol

| Variable | Kind | Current owner | Consumers | Main/ARAM | Target owner | Action | Blocker |
| --- | --- | --- | --- | --- | --- | --- | --- |
| reset_pvar | playervar | prelude/player-vars.opy | ai/core, ai/movement, ai/control; hero init modules; utilities/reset_frenemies.opy | M+A | prelude/player-vars.opy | K-P1 keep player reset/identity protocol | many init and AI consumers |
| heroNum | playervar | prelude/player-vars.opy | ai/core, ai/movement, ai/control; heroes/ana/init.opy, heroes/anran/init.opy | M+A | prelude/player-vars.opy | K-P1 keep AI hero identity state | shared AI lookup |
| botTemp | playervar | prelude/player-vars.opy | ai/control/common.opy, ai/control/genji.opy | M+A | prelude/player-vars.opy | K-P2 keep AI scratch state | shared AI control |
| botTarget | playervar | prelude/player-vars.opy | ai/core, ai/movement, ai/control, utilities/bot_aim2target.opy | M+A | prelude/player-vars.opy | K-P2 keep AI targeting state | shared AI control |
| Strafe | playervar | prelude/player-vars.opy | ai/movement/movement.opy, ai/control/venture.opy | M+A | prelude/player-vars.opy | K-P2 keep AI movement state | shared AI control |
| hudText | playervar | prelude/player-vars.opy | debug/changelog.opy, bootstrap/player-hud-text-init.opy, bootstrap/safety-blacklist-ban.opy, bootstrap/aram-safety-blacklist-ban.opy, utilities/reset_hero.opy, hero HUD rules | M+A | prelude/player-vars.opy | K-P3 keep shared HUD lifecycle state | many hero HUD writers |
| unaffected | playervar | prelude/player-vars.opy | modules/hero_rules/player_shared.opy and hero ability/status rules | M+A | prelude/player-vars.opy | K-P4 keep shared combat-status gate | intentionally cross-hero |
| heros | playervar | prelude/player-vars.opy | bootstrap/aram-extra-hero-pool.opy, bootstrap/aram-safety-blacklist-ban.opy | A | prelude/player-vars.opy | K-P5 keep ARAM hero-pool state | ARAM protocol |
| extra_hero | playervar | prelude/player-vars.opy | bootstrap/aram-player-lifecycle-and-reset.opy, bootstrap/aram-extra-hero-pool.opy | A | prelude/player-vars.opy | K-P5 keep ARAM lifecycle state | ARAM protocol |
| mov_speed_penalty | playervar | prelude/player-vars.opy | bootstrap lifecycle/reset, utilities/reset_stats.opy, Orisa/Brigitte/Ramattra/Roadhog/Zenyatta ARAM rules | M+A | prelude/player-vars.opy | K-P6 keep shared movement modifier state | multiple hero mechanics write it |
| mov_speed_buff | playervar | prelude/player-vars.opy | bootstrap lifecycle/reset, utilities/reset_stats.opy, Orisa/Brigitte/Ramattra/Roadhog/Reaper/Venture/Zenyatta ARAM rules | M+A | prelude/player-vars.opy | K-P6 keep shared movement modifier state | multiple hero mechanics write it |
| aram_extra_pool_applied | playervar | prelude/player-vars.opy | bootstrap/aram-extra-hero-pool.opy, bootstrap/aram-player-lifecycle-and-reset.opy, bootstrap/aram-safety-blacklist-ban.opy | A | prelude/player-vars.opy | K-P7 keep ARAM phase protocol | none |
| hero_switch_pvar | playervar | prelude/player-vars.opy | utilities/hero_switch.opy | M+A | prelude/player-vars.opy | K-P8 keep hero-init protocol storage | member aliases are public to init chain |

### move: hero-owned player state

| Variable | Kind | Current owner | Consumers | Main/ARAM | Target owner | Action | Blocker |
| --- | --- | --- | --- | --- | --- | --- | --- |
No unambiguous hero-owned player state remains after the P-WUYANG wave. The
Wuyang declaration and lifecycle reset now live in heroes/wuyang/state.opy.

### move: shared mechanic state

| Variable | Kind | Current owner | Consumers | Main/ARAM | Target owner | Action | Blocker |
| --- | --- | --- | --- | --- | --- | --- | --- |
The five scoped-damage declarations now live in modules/scoped-damage/state.opy
with both-entry include reach.

### defer: cross-module coupling must be resolved first

| Variable | Kind | Current owner | Consumers | Main/ARAM | Target owner | Action | Blocker |
| --- | --- | --- | --- | --- | --- | --- | --- |
| third_person | playervar | prelude/player-vars.opy | aram_protocol.opy, utilities/set_third_person.opy, heroes/soldier76/aram.opy | A | future modules/camera-policy/state.opy | D-P1 defer until mode protocol and Soldier camera toggles use an API | ARAM protocol directly resets the flag |
| orisa_buff | playervar | prelude/player-vars.opy | bootstrap lifecycle/reset, aram_protocol.opy, heroes/orisa/rules.opy, heroes/orisa/aram.opy, heroes/mauga/aram.opy | M+A | future heroes/orisa/state.opy plus reset interface | D-P2 defer until shared movement reset calls an Orisa semantic reset | non-Orisa modules write the state |
| taunt | playervar | prelude/player-vars.opy | main_mode_profile.opy, heroes/junker_queen/ability1.opy | M | future heroes/junker_queen/state.opy | D-P3 defer until mode profile exposes a taunt policy | mode profile directly owns the lifecycle |
| mauga_berserker_soul | playervar | prelude/player-vars.opy | modules/hero_rules/player_shared.opy, heroes/mauga/rules.opy, aram.opy, heroes/zarya/rules.opy, aram.opy, heroes/lifeweaver/ability2.opy, aram.opy, heroes/kiriko/ability2.opy, aram.opy, heroes/sombra/rules.opy | M+A | future modules/combat-policy/mauga-state.opy | D-P4 defer until healing and status consumers use a semantic predicate | several heroes read Mauga storage directly |
| brigitte_buff | playervar | prelude/player-vars.opy | aram_protocol.opy, bootstrap lifecycle/reset, heroes/brigitte/aram.opy, heroes/mauga/aram.opy, heroes/orisa/aram.opy | A | future modules/movement-status/state.opy or Brigitte API | D-P5 defer until ARAM reset paths stop clearing Brigitte storage | non-Brigitte modules write the state |
| zarya_graviton_buff | playervar | prelude/player-vars.opy | aram_protocol.opy, heroes/mauga/aram.opy, heroes/orisa/aram.opy | A | future modules/zarya-protection/state.opy | D-P6 defer until protection reset semantics are explicit | consumers only expose a shared reset dependency |
| KnockbackDirection | playervar | prelude/player-vars.opy | utilities/knockback.opy, heroes/zenyatta/melee.opy, rules.opy, aram.opy | M+A | future modules/knockback/state.opy | D-P7 defer until Knockback subroutine owns direction storage | utility and hero directly share the slot |
| hazard_buff | playervar | prelude/player-vars.opy | heroes/mauga/aram.opy, heroes/orisa/aram.opy | A | future heroes/hazard/state.opy or retired-state cleanup | D-P8 defer until the missing active Hazard writer is resolved | current active consumers are cross-hero reset paths |
| zarya_buff | playervar | prelude/player-vars.opy | modules/combat-policy/custom-effect-guards.opy, utilities/reset_hero.opy, heroes/zarya/init.opy, rules.opy, aram.opy, and direct guards in Genji/Freja/Hazard/Orisa/Roadhog/Shion/Sojourn | M+A | future modules/combat-policy/protection-state.opy | D-P9 defer remaining migration behind semantic protection policies | only Ana has the first policy wrapper; other consumers differ |
| heart_steel | playervar | prelude/player-vars.opy | aram_protocol.opy, heroes/doomfist/rules.opy, aram.opy, heroes/soldier76/aram.opy, heroes/torbjorn/aram.opy, heroes/ana/aram.opy, heroes/zenyatta/aram.opy, heroes/illari/aram.opy | A | split into named health-pool owners under affected hero/mechanic modules | D-P10 defer until the overloaded array is split by mechanic | unrelated hero mechanics reuse different indexes |
| has_nano | playervar | prelude/player-vars.opy | utilities/reset_hero.opy, heroes/ana/ability2.opy, ultimate.opy, aram.opy, heroes/emre/ultimate.opy, heroes/freja/rules.opy, aram.opy, heroes/genji/aram.opy, heroes/mauga/ability1.opy, aram.opy, heroes/roadhog/melee.opy, heroes/shion/aram.opy, heroes/sojourn/ultimate.opy, aram.opy | M+A | future modules/combat-policy/nano-state.opy | D-P11 defer until a Nano semantic predicate preserves all existing distinctions | many heroes read the shared flag directly |
| dmg_amplification | playervar | prelude/player-vars.opy | utilities/reset_hero.opy, heroes/mauga/rules.opy, aram.opy, heroes/reaper/ability1.opy, heroes/sierra/secondary.opy, heroes/soldier76/aram.opy, heroes/brigitte/ultimate.opy | M+A | future modules/combat-policy/damage-modifiers.opy | D-P12 defer until additive modifier ownership and reset semantics are defined | multiple writers stack and clear the same field |
| dmg_reduction | playervar | prelude/player-vars.opy | utilities/reset_hero.opy, heroes/mauga/rules.opy, aram.opy, heroes/reaper/ability2.opy, heroes/wuyang/ability1.opy, heroes/ana/aram.opy, heroes/brigitte/ultimate.opy | M+A | future modules/combat-policy/damage-modifiers.opy | D-P13 defer until additive modifier ownership and reset semantics are defined | multiple writers stack and clear the same field |
| hazard_using_ability_sec | playervar | prelude/player-vars.opy | ai/core/core-global-and-targeting.opy, heroes/hazard/rules.opy, aram.opy | M+A | future heroes/hazard/state.opy with an AI semantic guard | D-P14 defer until AI targeting no longer reads Hazard storage directly | AI core reads hero-private state |

## Migration waves

The wave identifiers in the Action column are ordering and review boundaries, not a
request to combine all rows into one commit.

1. The unambiguous G-* settings waves are complete in #70. Each migrated owner
   preserved the existing settings macro behavior and mode reach.
2. D-HEADSHOT, D-SOJOURN, and D-KNOCKBACK are policy/interface prerequisites. They
   must not be folded into the settings wave merely because their values look like
   hero settings.
3. P-WUYANG: move the one-hero player state together with an explicit lifecycle
   reset hook in a separate commit.
4. P-SCOPE is complete: the five scoped-damage fields share one responsibility-named
   owner with Main/ARAM includes and unchanged consumers.
5. D-P1 through D-P14 are blocked waves. Each blocker must be resolved with a
   semantic interface or a narrower state split before its declaration moves.
6. K-* rows remain in the prelude as shared infrastructure. Any move wave removes
   only its own migrated names and keeps the include-graph ownership boundary clear.

## Audit evidence and maintenance

- The current declaration inventory is 24 globalvar plus 27 playervar entries; the matrix has
  one row for each remaining declaration.
- The remaining prelude declarations are reachable from the applicable entry roots. The consumer paths above were
  searched across src, including bootstrap, AI, utilities, hero Main rules, and ARAM
  overlays.
- Ana_GrenadeDamage and Ana_NanoHealAmp are intentionally absent because #65 already
  moved them into Ana settings. burn_stack is absent because its behavior had no
  active consumer and the retired declaration/module were removed. The Domina names
  from #68 are absent because the current source has no declaration or active consumer
  for them.
- Re-run the declaration inventory and update this document before every #70 or #71
  migration wave. Do not treat the old .codex-tmp/player-vars-hero-split-todo.md file
  as authoritative.
