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

#!include "utilities/bot_aim2target.opy"
#!include "utilities/apply_custom_hp.opy"
#!include "utilities/clear_custom_hp.opy"
#!include "utilities/enable_all_abilities.opy"
#!include "utilities/reset_frenemies.opy"
#!include "utilities/disable_all_abilities.opy"
#!include "utilities/reset_stats.opy"
#!include "utilities/reset_statuses.opy"
#!include "utilities/reset_hero.opy"
#!include "utilities/knockback.opy"
#!include "utilities/set_third_person.opy"
#!include "utilities/remove_tank_passive.opy"
#!include "modules/bootstrap/blacklist.opy"

#
# ARAM-specific overrides (target: thin layer only)
#
#!include "aram_overrides.opy"

#!include "modules/ai/delimiter-begin.opy"
#!include "heroes/aram-init.opy"
#!include "modules/ai/delimiter-end.opy"
