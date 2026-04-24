# Useful constants and macros
#!include "constants/player_constants.opy"

# Prelude: settings and protocol declarations
#!include "modules/prelude/settings.opy"
#!include "modules/prelude/global-vars.opy"
#!include "modules/prelude/player-vars.opy"
#!include "modules/prelude/subroutine-names.opy"

# Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

#!postCompileHook "post-compile-hook.js"

# Bootstrap: init, anti-crash, blacklist, lifecycle
#!include "modules/bootstrap/init-and-settings.opy"
#!include "modules/bootstrap/anti-crash.opy"
#!include "modules/bootstrap/blacklist.opy"
#!include "modules/bootstrap/safety-blacklist-ban.opy"
#!include "modules/bootstrap/player-lifecycle-and-reset.opy"
#!include "main_mode_profile.opy"

# Utilities: shared subroutines and helpers
#!include "utilities/knockback.opy"
#!include "utilities/apply_custom_hp.opy"
#!include "utilities/clear_custom_hp.opy"
#!include "utilities/reset_frenemies.opy"
#!include "utilities/reset_stats.opy"
#!include "utilities/reset_statuses.opy"
#!include "utilities/execute_uppercut.opy"
#!include "utilities/enable_all_abilities.opy"
#!include "utilities/disable_all_abilities.opy"
#!include "utilities/reset_hero.opy"
#!include "utilities/remove_tank_passive.opy"
#!include "utilities/bot_aim2target.opy"

# AI core logic
#!include "modules/ai/delimiter-begin.opy"
#!include "modules/ai/core/core-global-and-targeting.opy"
#!include "modules/ai/movement/movement.opy"
#!include "modules/ai/control/common.opy"
#!include "modules/ai/control/heroes.opy"
#!include "modules/ai/delimiter-end.opy"

# Hero gameplay rules
#!include "heroes/init.main.opy"

# Debug and changelog
