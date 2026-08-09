# Prelude Variable Ownership Matrix

This is the canonical audit for issue #69. It covers every declaration that remains
in src/modules/prelude/global-vars.opy or src/modules/prelude/player-vars.opy after
the Ana settings pilot (#65), the Domina audit (#68), the retired burn-stack owner
(#66), and the Ana combat-policy pilot (#67).

The matrix is an audit and migration plan. It does not itself authorize a bulk move.
Each future wave must preserve the declaration name, explicit Workshop slot, Main and
ARAM reach, and the reset/lifecycle behavior recorded here.

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
- Current owner paths are relative to the repository root. The slot in parentheses is
  the stable declaration index recorded in tools/data/contract-guard/protocol-indexes.tsv.

## Global declarations

### keep: infrastructure/shared protocol

| Variable | Kind | Current owner | Consumers | Main/ARAM | Target owner | Action | Blocker |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Mark | globalvar (slot 0) | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, debug/changelog.opy | M+A | prelude/global-vars.opy | K-1 keep public mode metadata | none |
| Collaborator | globalvar (slot 1) | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, bootstrap/safety-blacklist-ban.opy | M+A | prelude/global-vars.opy | K-1 keep public mode metadata | none |
| ANTI_CRASH_ACTIVATE_PERCENT | globalvar (slot 2) | prelude/global-vars.opy | no active consumer outside prelude | M+A | prelude/global-vars.opy | K-2 retain reserved anti-crash ABI until a removal audit | no active reader found |
| ANTI_CRASH_HOLD_TIME | globalvar (slot 3) | prelude/global-vars.opy | no active consumer outside prelude | M+A | prelude/global-vars.opy | K-2 retain reserved anti-crash ABI until a removal audit | no active reader found |
| ANTI_CRASH_DEACTIVATE_PERCENT | globalvar (slot 4) | prelude/global-vars.opy | no active consumer outside prelude | M+A | prelude/global-vars.opy | K-2 retain reserved anti-crash ABI until a removal audit | no active reader found |
| Debug_UltimateGain | globalvar (slot 5) | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, debug/debug-ultimate.opy | M+A | prelude/global-vars.opy | K-1 keep debug infrastructure state | none |
| FalloffMin | globalvar (slot 6) | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, ai/movement/movement.opy | M+A | prelude/global-vars.opy | K-1 keep shared AI movement data | AI movement consumes the array directly |
| ProjectileSpeed | globalvar (slot 7) | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, ai/control/ana.opy, ai/control/kiriko.opy | M+A | prelude/global-vars.opy | K-1 keep shared hero/AI projectile data | AI and settings consumers share the data |
| BotHeroArray | globalvar (slot 8) | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, heroes/ana/init.opy, heroes/anran/init.opy | M+A | prelude/global-vars.opy | K-1 keep bot roster infrastructure | none |
| Heros | globalvar (slot 9) | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, bootstrap/safety-blacklist-ban.opy, bootstrap/aram-safety-blacklist-ban.opy, ai/core/core-global-and-targeting.opy | M+A | prelude/global-vars.opy | K-1 keep roster/protocol state | none |
| Hero_BAN | globalvar (slot 10) | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, bootstrap/safety-blacklist-ban.opy, bootstrap/aram-safety-blacklist-ban.opy, bootstrap/aram-extra-hero-pool.opy | M+A | prelude/global-vars.opy | K-1 keep mode selection state | none |
| Counters | globalvar (slot 34) | prelude/global-vars.opy | ai/core/core-global-and-targeting.opy | M+A | prelude/global-vars.opy | K-1 keep AI counter protocol | none |
| Counter_Bot | globalvar (slot 35) | prelude/global-vars.opy | ai/core/core-global-and-targeting.opy | M+A | prelude/global-vars.opy | K-1 keep AI counter protocol | none |
| Blacklist | globalvar (slot 36) | prelude/global-vars.opy | bootstrap/blacklist.opy | M+A | prelude/global-vars.opy | K-1 keep safety infrastructure | none |
| CustomAI | globalvar (slot 37) | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, ai/core/core-global-and-targeting.opy | M+A | prelude/global-vars.opy | K-1 keep AI mode configuration | none |
| CustomAIArray | globalvar (slot 38) | prelude/global-vars.opy | bootstrap/init-and-settings.opy, bootstrap/aram-mode-settings.opy, ai/core/core-global-and-targeting.opy, ai/control/common.opy | M+A | prelude/global-vars.opy | K-1 keep AI roster configuration | none |
| ChangelogHeroes | globalvar (slot 39) | prelude/global-vars.opy | debug/changelog.opy, utilities/changelog_text.opy | M+A | prelude/global-vars.opy | K-1 keep changelog table protocol | none |
| ChangelogBodyTable | globalvar (slot 40) | prelude/global-vars.opy | debug/changelog.opy, utilities/changelog_text.opy | M+A | prelude/global-vars.opy | K-1 keep changelog table protocol | none |

### move: hero-owned global state/settings

Each row is an independent hero-settings migration. The target settings path must
declare the old slot explicitly; if the ARAM settings path is listed, both entry
settings modules must retain the same logical name and slot.

| Variable | Kind | Current owner | Consumers | Main/ARAM | Target owner | Action | Blocker |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Genji | globalvar (slot 11) | prelude/global-vars.opy | heroes/genji/settings.opy, init.opy, ability2.opy, ultimate.opy, aram.opy; utilities/changelog_text.opy | M+A | heroes/genji/settings.opy | G-GENJI move setting with slot 11 | changelog_text display read |
| Orisa_Fortify | globalvar (slot 12) | prelude/global-vars.opy | heroes/orisa/settings.opy, settings.aram.opy, ability1.opy, rules.opy, aram.opy; utilities/changelog_text.opy | M+A | heroes/orisa/settings.opy and settings.aram.opy | G-ORISA move setting with slot 12 | changelog_text display read |
| ZaryaBuff | globalvar (slot 14) | prelude/global-vars.opy | heroes/zarya/settings.opy, settings.aram.opy, init.opy, rules.opy, aram.opy; utilities/changelog_text.opy | M+A | heroes/zarya/settings.opy and settings.aram.opy | G-ZARYA move setting with slot 14 | changelog_text display read |
| IllariBuff | globalvar (slot 15) | prelude/global-vars.opy | heroes/illari/settings.opy, ultimate.opy, aram.opy | M+A | heroes/illari/settings.opy | G-ILLARI move setting with slot 15 | none |
| MercyBuff | globalvar (slot 16) | prelude/global-vars.opy | heroes/mercy/settings.opy, ultimate.opy; utilities/changelog_text.opy | M+A | heroes/mercy/settings.opy | G-MERCY move setting with slot 16 | changelog_text display read |
| SombraBuff | globalvar (slot 17) | prelude/global-vars.opy | heroes/sombra/settings.opy, rules.opy, aram.opy; utilities/changelog_text.opy | M+A | heroes/sombra/settings.opy | G-SOMBRA move setting with slot 17 | changelog_text display read |
| Tracer_Ability | globalvar (slot 18) | prelude/global-vars.opy | heroes/tracer/settings.opy, ability2.opy | M+A | heroes/tracer/settings.opy | G-TRACER move setting with slot 18 | none |
| ReaperBuff | globalvar (slot 19) | prelude/global-vars.opy | heroes/reaper/settings.opy, passive.opy, ability1.opy, ability2.opy, secondary.opy, ultimate.opy, aram.opy | M+A | heroes/reaper/settings.opy | G-REAPER move setting with slot 19 | none |
| MaugaBuff | globalvar (slot 20) | prelude/global-vars.opy | heroes/mauga/settings.opy, settings.aram.opy, ability1.opy, ability2.opy, rules.opy, aram.opy | M+A | heroes/mauga/settings.opy and settings.aram.opy | G-MAUGA move setting with slot 20 | none |
| S76Buff | globalvar (slot 21) | prelude/global-vars.opy | heroes/soldier76/settings.opy, settings.aram.opy, rules.opy, aram.opy; utilities/changelog_text.opy | M+A | heroes/soldier76/settings.opy and settings.aram.opy | G-SOLDIER move setting with slot 21 | changelog_text display read |
| HazardBuff | globalvar (slot 23) | prelude/global-vars.opy | heroes/hazard/settings.opy, settings.aram.opy, rules.opy, aram.opy; utilities/changelog_text.opy | M+A | heroes/hazard/settings.opy and settings.aram.opy | G-HAZARD move setting with slot 23 | changelog_text display read |
| FrejaBuff | globalvar (slot 24) | prelude/global-vars.opy | heroes/freja/settings.opy, settings.aram.opy, rules.opy, aram.opy | M+A | heroes/freja/settings.opy and settings.aram.opy | G-FREJA move setting with slot 24 | none |
| WuyangBuff | globalvar (slot 25) | prelude/global-vars.opy | heroes/wuyang/settings.opy, ability1.opy; utilities/changelog_text.opy | M+A | heroes/wuyang/settings.opy | G-WUYANG move setting with slot 25 | changelog_text display read |
| Brigitte | globalvar (slot 26) | prelude/global-vars.opy | heroes/brigitte/settings.opy, settings.aram.opy, ability2.opy, ultimate.opy, aram.opy | M+A | heroes/brigitte/settings.opy and settings.aram.opy | G-BRIGITTE move setting with slot 26 | none |
| SigmaBuff | globalvar (slot 27) | prelude/global-vars.opy | heroes/sigma/settings.opy, settings.aram.opy, primary.opy, aram.opy; utilities/changelog_text.opy | M+A | heroes/sigma/settings.opy and settings.aram.opy | G-SIGMA move setting with slot 27 | changelog_text display read |
| JunoBuff | globalvar (slot 28) | prelude/global-vars.opy | heroes/juno/settings.opy, settings.aram.opy, ultimate.opy; utilities/changelog_text.opy | M+A | heroes/juno/settings.opy and settings.aram.opy | G-JUNO move setting with slot 28 | changelog_text display read |
| DoomBuff | globalvar (slot 30) | prelude/global-vars.opy | heroes/doomfist/settings.opy, settings.aram.opy, ability2.opy, aram.opy; utilities/changelog_text.opy | M+A | heroes/doomfist/settings.opy and settings.aram.opy | G-DOOM move setting with slot 30 | changelog_text display read |
| Ram_Annihilation | globalvar (slot 32) | prelude/global-vars.opy | heroes/ramattra/settings.opy, settings.aram.opy, ability1.opy, secondary.opy, ultimate.opy, aram.opy; utilities/changelog_text.opy | M+A | heroes/ramattra/settings.opy and settings.aram.opy | G-RAM move setting with slot 32 | changelog_text display read |
| VendettaBuff | globalvar (slot 33) | prelude/global-vars.opy | heroes/vendetta/settings.opy, primary.opy, ability1.opy, ultimate.opy; utilities/changelog_text.opy | M+A | heroes/vendetta/settings.opy | G-VENDETTA move setting with slot 33 | changelog_text display read |
| HanzoBuff | globalvar (slot 41) | prelude/global-vars.opy | heroes/hanzo/settings.opy, settings.aram.opy, rules.opy, aram.opy; utilities/changelog_text.opy | M+A | heroes/hanzo/settings.opy and settings.aram.opy | G-HANZO move setting with slot 41 | changelog_text display read |
| BaptisteBuff | globalvar (slot 42) | prelude/global-vars.opy | heroes/baptiste/settings.opy, settings.aram.opy, rules.opy, aram.opy; utilities/changelog_text.opy | M+A | heroes/baptiste/settings.opy and settings.aram.opy | G-BAPTISTE move setting with slot 42 | changelog_text display read |
| CassidyBuff | globalvar (slot 43) | prelude/global-vars.opy | heroes/cassidy/settings.opy, ability2.opy | M+A | heroes/cassidy/settings.opy | G-CASSIDY move setting with slot 43 | none |
| LucioBuff | globalvar (slot 44) | prelude/global-vars.opy | heroes/lucio/settings.opy, rules.opy; utilities/changelog_text.opy | M+A | heroes/lucio/settings.opy | G-LUCIO move setting with slot 44 | changelog_text display read |
| JunkratBuff | globalvar (slot 45) | prelude/global-vars.opy | heroes/junkrat/settings.opy, rules.opy | M+A | heroes/junkrat/settings.opy | G-JUNKRAT move setting with slot 45 | none |
| MoiraBuff | globalvar (slot 46) | prelude/global-vars.opy | aram_protocol.opy, heroes/moira/settings.opy, settings.aram.opy, rules.opy, aram.opy; utilities/changelog_text.opy | M+A | heroes/moira/settings.opy and settings.aram.opy | G-MOIRA move setting with slot 46 | aram_protocol and changelog_text reads |
| ReinhardtBuff | globalvar (slot 47) | prelude/global-vars.opy | heroes/reinhardt/settings.opy, settings.aram.opy, rules.opy, ability2.opy, aram.opy | M+A | heroes/reinhardt/settings.opy and settings.aram.opy | G-REINHARDT move setting with slot 47 | none |
| VentureBuff | globalvar (slot 48) | prelude/global-vars.opy | heroes/venture/settings.opy, ability1.opy, aram.opy | M+A | heroes/venture/settings.opy | G-VENTURE move setting with slot 48 | none |
| WreckingBallBuff | globalvar (slot 49) | prelude/global-vars.opy | heroes/wrecking_ball/settings.opy, rules.opy, aram.opy | M+A | heroes/wrecking_ball/settings.opy | G-WRECKING-BALL move setting with slot 49 | none |
| AnranBuff | globalvar (slot 50) | prelude/global-vars.opy | heroes/anran/settings.opy, settings.aram.opy, ability2.opy, burning.opy; utilities/changelog_text.opy | M+A | heroes/anran/settings.opy and settings.aram.opy | G-ANRAN move setting with slot 50 | changelog_text display read |
| BastionBuff | globalvar (slot 51) | prelude/global-vars.opy | heroes/bastion/settings.opy, settings.aram.opy, ability1.opy, aram.opy | M+A | heroes/bastion/settings.opy and settings.aram.opy | G-BASTION move setting with slot 51 | none |
| DominaBuff | globalvar (slot 52) | prelude/global-vars.opy | heroes/domina/settings.opy, rules.opy, ultimate.opy | M+A | heroes/domina/settings.opy | G-DOMINA move setting with slot 52 | none |
| EchoBuff | globalvar (slot 53) | prelude/global-vars.opy | heroes/echo/settings.opy, ability2.opy, ultimate.opy; utilities/changelog_text.opy | M+A | heroes/echo/settings.opy | G-ECHO move setting with slot 53 | changelog_text display read |
| EmreBuff | globalvar (slot 54) | prelude/global-vars.opy | heroes/emre/settings.opy, settings.aram.opy, ability2.opy, ultimate.opy, aram.opy; utilities/changelog_text.opy | M+A | heroes/emre/settings.opy and settings.aram.opy | G-EMRE move setting with slot 54 | changelog_text display read |
| JetpackCatBuff | globalvar (slot 55) | prelude/global-vars.opy | heroes/jetpack_cat/settings.opy, settings.aram.opy, ability1.opy, ability2.opy, rules.opy, ultimate.opy, aram.opy | M+A | heroes/jetpack_cat/settings.opy and settings.aram.opy | G-JETPACK-CAT move setting with slot 55 | none |
| JunkerQueenBuff | globalvar (slot 56) | prelude/global-vars.opy | heroes/junker_queen/settings.opy, ability1.opy, ability2.opy | M+A | heroes/junker_queen/settings.opy | G-JUNKER-QUEEN move setting with slot 56 | none |
| LifeweaverBuff | globalvar (slot 57) | prelude/global-vars.opy | heroes/lifeweaver/settings.opy, settings.aram.opy, aram.opy | M+A | heroes/lifeweaver/settings.opy and settings.aram.opy | G-LIFEWEAVER move setting with slot 57 | none |
| MeiBuff | globalvar (slot 58) | prelude/global-vars.opy | heroes/mei/settings.opy, settings.aram.opy, aram.opy | M+A | heroes/mei/settings.opy and settings.aram.opy | G-MEI move setting with slot 58 | none |
| MizukiBuff | globalvar (slot 59) | prelude/global-vars.opy | heroes/mizuki/settings.opy, ability1.opy, ability2.opy, secondary.opy | M+A | heroes/mizuki/settings.opy | G-MIZUKI move setting with slot 59 | none |
| PharahBuff | globalvar (slot 60) | prelude/global-vars.opy | heroes/pharah/settings.opy, settings.aram.opy, aram.opy | M+A | heroes/pharah/settings.opy and settings.aram.opy | G-PHARAH move setting with slot 60 | none |
| RoadhogBuff | globalvar (slot 61) | prelude/global-vars.opy | heroes/roadhog/settings.opy, settings.aram.opy, ability2.opy, aram.opy | M+A | heroes/roadhog/settings.opy and settings.aram.opy | G-ROADHOG move setting with slot 61 | none |
| SierraBuff | globalvar (slot 62) | prelude/global-vars.opy | heroes/sierra/settings.opy, ability1.opy, secondary.opy, ultimate.opy; utilities/changelog_text.opy | M+A | heroes/sierra/settings.opy | G-SIERRA move setting with slot 62 | changelog_text display read |
| TorbjornBuff | globalvar (slot 63) | prelude/global-vars.opy | heroes/torbjorn/settings.opy, settings.aram.opy, aram.opy | M+A | heroes/torbjorn/settings.opy and settings.aram.opy | G-TORBJORN move setting with slot 63 | none |
| WidowmakerBuff | globalvar (slot 64) | prelude/global-vars.opy | heroes/widowmaker/settings.opy, settings.aram.opy, rules.opy, ultimate.opy, aram.opy | M+A | heroes/widowmaker/settings.opy and settings.aram.opy | G-WIDOWMAKER move setting with slot 64 | none |
| WinstonBuff | globalvar (slot 65) | prelude/global-vars.opy | heroes/winston/settings.opy, settings.aram.opy, secondary.opy, aram.opy; utilities/changelog_text.opy | M+A | heroes/winston/settings.opy and settings.aram.opy | G-WINSTON move setting with slot 65 | changelog_text display read |
| ShionBuff | globalvar (slot 66) | prelude/global-vars.opy | heroes/shion/settings.opy, settings.aram.opy, rules.opy, secondary.opy, ultimate.opy, aram.opy; utilities/changelog_text.opy | M+A | heroes/shion/settings.opy and settings.aram.opy | G-SHION move setting with slot 66 | changelog_text display read |

### defer: cross-module coupling must be resolved first

| Variable | Kind | Current owner | Consumers | Main/ARAM | Target owner | Action | Blocker |
| --- | --- | --- | --- | --- | --- | --- | --- |
| HeadshotDamage | globalvar (slot 13) | prelude/global-vars.opy | heroes/ashe/rules.opy, hanzo/aram.opy, baptiste/aram.opy, kiriko/headshot.opy, zenyatta/rules.opy, zenyatta/aram.opy; utilities/changelog_text.opy | M+A | future modules/combat-policy/headshot-settings.opy or explicit hero settings API | D-HEADSHOT defer until the headshot policy is named and its readers use it | five hero consumers read one shared array |
| SojournBuff | globalvar (slot 22) | prelude/global-vars.opy | heroes/sojourn/settings.opy, ultimate.opy, aram.opy; heroes/genji/aram.opy; utilities/changelog_text.opy | M+A | heroes/sojourn/settings.opy plus a semantic Genji execution input | D-SOJOURN defer until the cross-hero Genji read is removed | Genji directly consumes Sojourn storage |
| Zen_KnockupStrength | globalvar (slot 31) | prelude/global-vars.opy | utilities/knockback.opy; heroes/zenyatta/settings.opy | M+A | future modules/knockback/state.opy | D-KNOCKBACK defer until Knockback exposes a semantic strength interface | utility and hero directly share the setting |

## Player declarations

### keep: infrastructure/shared protocol

| Variable | Kind | Current owner | Consumers | Main/ARAM | Target owner | Action | Blocker |
| --- | --- | --- | --- | --- | --- | --- | --- |
| reset_pvar | playervar (slot 0) | prelude/player-vars.opy | ai/core, ai/movement, ai/control; hero init modules; utilities/reset_frenemies.opy | M+A | prelude/player-vars.opy | K-P1 keep player reset/identity protocol | many init and AI consumers |
| heroNum | playervar (slot 1) | prelude/player-vars.opy | ai/core, ai/movement, ai/control; heroes/ana/init.opy, heroes/anran/init.opy | M+A | prelude/player-vars.opy | K-P1 keep AI hero identity state | shared AI lookup |
| botTemp | playervar (slot 2) | prelude/player-vars.opy | ai/control/common.opy, ai/control/genji.opy | M+A | prelude/player-vars.opy | K-P2 keep AI scratch state | shared AI control |
| botTarget | playervar (slot 3) | prelude/player-vars.opy | ai/core, ai/movement, ai/control, utilities/bot_aim2target.opy | M+A | prelude/player-vars.opy | K-P2 keep AI targeting state | shared AI control |
| Strafe | playervar (slot 4) | prelude/player-vars.opy | ai/movement/movement.opy, ai/control/venture.opy | M+A | prelude/player-vars.opy | K-P2 keep AI movement state | shared AI control |
| hudText | playervar (slot 6) | prelude/player-vars.opy | debug/changelog.opy, bootstrap/player-hud-text-init.opy, bootstrap/safety-blacklist-ban.opy, bootstrap/aram-safety-blacklist-ban.opy, utilities/reset_hero.opy, hero HUD rules | M+A | prelude/player-vars.opy | K-P3 keep shared HUD lifecycle state | many hero HUD writers |
| unaffected | playervar (slot 7) | prelude/player-vars.opy | modules/hero_rules/player_shared.opy and hero ability/status rules | M+A | prelude/player-vars.opy | K-P4 keep shared combat-status gate | intentionally cross-hero |
| heros | playervar (slot 8) | prelude/player-vars.opy | bootstrap/aram-extra-hero-pool.opy, bootstrap/aram-safety-blacklist-ban.opy | A | prelude/player-vars.opy | K-P5 keep ARAM hero-pool state | ARAM protocol |
| extra_hero | playervar (slot 9) | prelude/player-vars.opy | bootstrap/aram-player-lifecycle-and-reset.opy, bootstrap/aram-extra-hero-pool.opy | A | prelude/player-vars.opy | K-P5 keep ARAM lifecycle state | ARAM protocol |
| mov_speed_penalty | playervar (slot 10) | prelude/player-vars.opy | bootstrap lifecycle/reset, utilities/reset_stats.opy, Orisa/Brigitte/Ramattra/Roadhog/Zenyatta ARAM rules | M+A | prelude/player-vars.opy | K-P6 keep shared movement modifier state | multiple hero mechanics write it |
| mov_speed_buff | playervar (slot 11) | prelude/player-vars.opy | bootstrap lifecycle/reset, utilities/reset_stats.opy, Orisa/Brigitte/Ramattra/Roadhog/Reaper/Venture/Zenyatta ARAM rules | M+A | prelude/player-vars.opy | K-P6 keep shared movement modifier state | multiple hero mechanics write it |
| aram_extra_pool_applied | playervar (slot 31) | prelude/player-vars.opy | bootstrap/aram-extra-hero-pool.opy, bootstrap/aram-player-lifecycle-and-reset.opy, bootstrap/aram-safety-blacklist-ban.opy | A | prelude/player-vars.opy | K-P7 keep ARAM phase protocol | none |
| hero_switch_pvar | playervar (slot 33) | prelude/player-vars.opy | utilities/hero_switch.opy | M+A | prelude/player-vars.opy | K-P8 keep hero-init protocol storage | member aliases are public to init chain |

### move: hero-owned player state

| Variable | Kind | Current owner | Consumers | Main/ARAM | Target owner | Action | Blocker |
| --- | --- | --- | --- | --- | --- | --- | --- |
| wuyang_buff | playervar (slot 18) | prelude/player-vars.opy | heroes/wuyang/ability2.opy; bootstrap/player-lifecycle-and-reset.opy; bootstrap/aram-player-lifecycle-and-reset.opy | M+A | new heroes/wuyang/state.opy included by both entry manifests | P-WUYANG move Wuyang-only state with slot 18 and an explicit reset hook | shared lifecycle currently clears fields directly |

### move: shared mechanic state

| Variable | Kind | Current owner | Consumers | Main/ARAM | Target owner | Action | Blocker |
| --- | --- | --- | --- | --- | --- | --- | --- |
| scoped_shot_distance | playervar (slot 26) | prelude/player-vars.opy | heroes/widowmaker/rules.opy, aram.opy; heroes/cassidy/primary.opy | M+A | new modules/scoped-damage/state.opy | P-SCOPE move scoped-damage state with slot 26 | Widowmaker and Cassidy currently share fields directly |
| scoped_damage_base | playervar (slot 27) | prelude/player-vars.opy | heroes/widowmaker/rules.opy, aram.opy; heroes/cassidy/primary.opy | M+A | new modules/scoped-damage/state.opy | P-SCOPE move scoped-damage state with slot 27 | shared calculation needs an explicit owner |
| ow2_scoped_damage_falloff_scalar | playervar (slot 28) | prelude/player-vars.opy | heroes/widowmaker/rules.opy, aram.opy; heroes/cassidy/primary.opy | M+A | new modules/scoped-damage/state.opy | P-SCOPE move scoped-damage state with slot 28 | shared calculation needs an explicit owner |
| ow1_scoped_damage_falloff_scalar | playervar (slot 29) | prelude/player-vars.opy | heroes/widowmaker/rules.opy, aram.opy; heroes/cassidy/primary.opy | M+A | new modules/scoped-damage/state.opy | P-SCOPE move scoped-damage state with slot 29 | shared calculation needs an explicit owner |
| expected_scoped_damage | playervar (slot 30) | prelude/player-vars.opy | heroes/widowmaker/rules.opy, aram.opy; heroes/cassidy/primary.opy | M+A | new modules/scoped-damage/state.opy | P-SCOPE move scoped-damage state with slot 30 | shared calculation needs an explicit owner |

### defer: cross-module coupling must be resolved first

| Variable | Kind | Current owner | Consumers | Main/ARAM | Target owner | Action | Blocker |
| --- | --- | --- | --- | --- | --- | --- | --- |
| third_person | playervar (slot 5) | prelude/player-vars.opy | aram_protocol.opy, utilities/set_third_person.opy, heroes/soldier76/aram.opy | A | future modules/camera-policy/state.opy | D-P1 defer until mode protocol and Soldier camera toggles use an API | ARAM protocol directly resets the flag |
| orisa_buff | playervar (slot 12) | prelude/player-vars.opy | bootstrap lifecycle/reset, aram_protocol.opy, heroes/orisa/rules.opy, heroes/orisa/aram.opy, heroes/mauga/aram.opy | M+A | future heroes/orisa/state.opy plus reset interface | D-P2 defer until shared movement reset calls an Orisa semantic reset | non-Orisa modules write the state |
| taunt | playervar (slot 13) | prelude/player-vars.opy | main_mode_profile.opy, heroes/junker_queen/ability1.opy | M | future heroes/junker_queen/state.opy | D-P3 defer until mode profile exposes a taunt policy | mode profile directly owns the lifecycle |
| mauga_berserker_soul | playervar (slot 14) | prelude/player-vars.opy | modules/hero_rules/player_shared.opy, heroes/mauga/rules.opy, aram.opy, heroes/zarya/rules.opy, aram.opy, heroes/lifeweaver/ability2.opy, aram.opy, heroes/kiriko/ability2.opy, aram.opy, heroes/sombra/rules.opy | M+A | future modules/combat-policy/mauga-state.opy | D-P4 defer until healing and status consumers use a semantic predicate | several heroes read Mauga storage directly |
| brigitte_buff | playervar (slot 15) | prelude/player-vars.opy | aram_protocol.opy, bootstrap lifecycle/reset, heroes/brigitte/aram.opy, heroes/mauga/aram.opy, heroes/orisa/aram.opy | A | future modules/movement-status/state.opy or Brigitte API | D-P5 defer until ARAM reset paths stop clearing Brigitte storage | non-Brigitte modules write the state |
| zarya_graviton_buff | playervar (slot 16) | prelude/player-vars.opy | aram_protocol.opy, heroes/mauga/aram.opy, heroes/orisa/aram.opy | A | future modules/zarya-protection/state.opy | D-P6 defer until protection reset semantics are explicit | consumers only expose a shared reset dependency |
| KnockbackDirection | playervar (slot 17) | prelude/player-vars.opy | utilities/knockback.opy, heroes/zenyatta/melee.opy, rules.opy, aram.opy | M+A | future modules/knockback/state.opy | D-P7 defer until Knockback subroutine owns direction storage | utility and hero directly share the slot |
| hazard_buff | playervar (slot 19) | prelude/player-vars.opy | heroes/mauga/aram.opy, heroes/orisa/aram.opy | A | future heroes/hazard/state.opy or retired-state cleanup | D-P8 defer until the missing active Hazard writer is resolved | current active consumers are cross-hero reset paths |
| zarya_buff | playervar (slot 20) | prelude/player-vars.opy | modules/combat-policy/custom-effect-guards.opy, utilities/reset_hero.opy, heroes/zarya/init.opy, rules.opy, aram.opy, and direct guards in Genji/Freja/Hazard/Orisa/Roadhog/Shion/Sojourn | M+A | future modules/combat-policy/protection-state.opy | D-P9 defer remaining migration behind semantic protection policies | only Ana has the first policy wrapper; other consumers differ |
| heart_steel | playervar (slot 21) | prelude/player-vars.opy | aram_protocol.opy, heroes/doomfist/rules.opy, aram.opy, heroes/soldier76/aram.opy, heroes/torbjorn/aram.opy, heroes/ana/aram.opy, heroes/zenyatta/aram.opy, heroes/illari/aram.opy | A | split into named health-pool owners under affected hero/mechanic modules | D-P10 defer until the overloaded array is split by mechanic | unrelated hero mechanics reuse different indexes |
| has_nano | playervar (slot 22) | prelude/player-vars.opy | utilities/reset_hero.opy, heroes/ana/ability2.opy, ultimate.opy, aram.opy, heroes/emre/ultimate.opy, heroes/freja/rules.opy, aram.opy, heroes/genji/aram.opy, heroes/mauga/ability1.opy, aram.opy, heroes/roadhog/melee.opy, heroes/shion/aram.opy, heroes/sojourn/ultimate.opy, aram.opy | M+A | future modules/combat-policy/nano-state.opy | D-P11 defer until a Nano semantic predicate preserves all existing distinctions | many heroes read the shared flag directly |
| dmg_amplification | playervar (slot 23) | prelude/player-vars.opy | utilities/reset_hero.opy, heroes/mauga/rules.opy, aram.opy, heroes/reaper/ability1.opy, heroes/sierra/secondary.opy, heroes/soldier76/aram.opy, heroes/brigitte/ultimate.opy | M+A | future modules/combat-policy/damage-modifiers.opy | D-P12 defer until additive modifier ownership and reset semantics are defined | multiple writers stack and clear the same field |
| dmg_reduction | playervar (slot 24) | prelude/player-vars.opy | utilities/reset_hero.opy, heroes/mauga/rules.opy, aram.opy, heroes/reaper/ability2.opy, heroes/wuyang/ability1.opy, heroes/ana/aram.opy, heroes/brigitte/ultimate.opy | M+A | future modules/combat-policy/damage-modifiers.opy | D-P13 defer until additive modifier ownership and reset semantics are defined | multiple writers stack and clear the same field |
| hazard_using_ability_sec | playervar (slot 25) | prelude/player-vars.opy | ai/core/core-global-and-targeting.opy, heroes/hazard/rules.opy, aram.opy | M+A | future heroes/hazard/state.opy with an AI semantic guard | D-P14 defer until AI targeting no longer reads Hazard storage directly | AI core reads hero-private state |

## Migration waves

The wave identifiers in the Action column are ordering and review boundaries, not a
request to combine all rows into one commit.

1. G-GENJI through G-SHION: migrate one hero settings owner at a time. Keep the
   existing settings macro behavior, carry the old global slot, and update the
   changelog display dependency in the same hero-scoped commit when listed.
2. D-HEADSHOT, D-SOJOURN, and D-KNOCKBACK are policy/interface prerequisites. They
   must not be folded into the settings wave merely because their values look like
   hero settings.
3. P-WUYANG: move the one-hero player state together with an explicit lifecycle
   reset hook in a separate commit.
4. P-SCOPE: move the five scoped-damage fields as one responsibility-named mechanic
   unit, with Main/ARAM includes and a focused consumer check.
5. D-P1 through D-P14 are blocked waves. Each blocker must be resolved with a
   semantic interface or a narrower state split before its declaration moves.
6. K-* rows remain in the prelude ABI. The protocol baseline must retain their order
   and slots while any move wave removes only its own migrated names.

## Audit evidence and maintenance

- The declaration inventory is 66 globalvar plus 33 playervar entries; the matrix has
  one row for each remaining declaration.
- Both entry roots include the prelude declarations. The consumer paths above were
  searched across src, including bootstrap, AI, utilities, hero Main rules, and ARAM
  overlays.
- Ana_GrenadeDamage and Ana_NanoHealAmp are intentionally absent because #65 already
  moved them into Ana settings. burn_stack is absent because #66 moved its preserved
  slot into modules/burning/state. The Domina names from #68 are absent because the
  current source has no declaration or active consumer for them.
- Re-run the declaration inventory and update this document before every #70 or #71
  migration wave. Do not treat the old .codex-tmp/player-vars-hero-split-todo.md file
  as authoritative.
