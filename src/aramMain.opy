#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!postCompileHook "post-compile-hook.js"

#
# Mode config: constants + ARAM settings/protocol
#
#!include "constants/player_constants.opy"

#!include "aram_settings.opy"
#!include "aram_protocol.opy"

#
# Shared leaves reused from mainline modules
#
#!include "modules/ai/00-delimiter-begin.opy"
#!include "modules/ai/99-delimiter-end.opy"
#!include "heroes/init.aram.opy"
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
#!include "modules/bootstrap/11-blacklist.opy"

#
# ARAM-specific overrides (target: thin layer only)
#
#!include "aram_overrides.opy"
