#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

#!postCompileHook "post-compile-hook.js"

#
# Mode config: constants + ARAM settings/protocol
#
#!include "utilities/macros.opy"
#!include "constants/ow2_hero_defaults.opy"
#!include "constants/player_constants.opy"

#!include "aram_settings.opy"
#!include "modules/prelude/global-vars.opy"
#!include "modules/prelude/player-vars.opy"
#!include "modules/prelude/subroutine.opy"
#!include "aram_protocol.opy"

#
# Shared leaves reused from mainline modules
#
#!include "modules/bootstrap/aram-mode-settings.opy"
#!include "modules/bootstrap/aram-hero-ability-settings.opy"
#!include "modules/bootstrap/aram-safety-blacklist-ban.opy"
#!include "utilities/bot_aim2target.opy"
#!include "utilities/clear_custom_hp.opy"
#!include "utilities/enable_all_abilities.opy"
#!include "utilities/reset_frenemies.opy"
#!include "utilities/hero_switch.opy"
#!include "utilities/disable_all_abilities.opy"
#!include "utilities/reset_stats.opy"
#!include "utilities/knockback.opy"
#!include "utilities/set_third_person.opy"
#!include "utilities/remove_tank_passive.opy"
#!include "modules/bootstrap/blacklist.opy"

#
# AI core logic
#
#!include "modules/ai/delimiter-begin.opy"
#!include "modules/ai/core/core-global-and-targeting.opy"
#!include "modules/ai/movement/movement.opy"
#!include "modules/ai/control/common.opy"
#!include "modules/ai/control/heroes.opy"
#!include "modules/ai/delimiter-end.opy"

#
# ARAM-specific hero gameplay rules
#
#!include "aram_overrides.opy"

#
# Reset and hero init
#
#!include "utilities/reset_statuses.opy"
#!include "utilities/reset_hero.opy"
#!include "modules/bootstrap/aram-player-lifecycle-and-reset.opy"
#!include "heroes/aram.opy"

#
# Debug and changelog
#
#!include "modules/debug/changelog.opy"
#!include "utilities/changelog_text.opy"
