# Useful constants and macros
#!include "constants/player_constants.opy"

# Prelude: settings and protocol declarations
#!include "modules/prelude/00-settings.opy"
#!include "modules/prelude/01-global-vars.opy"
#!include "modules/prelude/02-player-vars.opy"
#!include "modules/prelude/03-subroutine-names.opy"

# Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

#!postCompileHook "post-compile-hook.js"

# Bootstrap: init, anti-crash, blacklist, lifecycle
#!include "modules/bootstrap/00-init-and-settings.opy"
#!include "modules/bootstrap/09-anti-crash.opy"
#!include "modules/bootstrap/11-blacklist.opy"
#!include "modules/bootstrap/10-safety-blacklist-ban.opy"
#!include "modules/bootstrap/20-player-lifecycle-and-reset.opy"
#!include "../../main_mode_profile.opy"

# Utilities: shared subroutines and helpers
#!include "../../utilities/knockback.opy"
#!include "../../utilities/apply_custom_hp.opy"
#!include "../../utilities/clear_custom_hp.opy"
#!include "../../utilities/reset_frenemies.opy"
#!include "../../utilities/reset_stats.opy"
#!include "../../utilities/reset_statuses.opy"
#!include "../../utilities/execute_uppercut.opy"
#!include "../../utilities/enable_all_abilities.opy"
#!include "../../utilities/disable_all_abilities.opy"
#!include "../../utilities/reset_hero.opy"
#!include "../../utilities/remove_tank_passive.opy"
#!include "../../utilities/bot_aim2target.opy"

# AI core logic
#!include "../ai/00-delimiter-begin.opy"
#!include "../ai/core/10-core-global-and-targeting.opy"
#!include "../ai/movement/20-movement.opy"
#!include "../ai/control/30-control-tracer-reaper-genji.opy"
#!include "../ai/control/31-control-supports.opy"
#!include "../ai/control/32-control-tanks.opy"
#!include "../ai/control/33-control-projectile-and-special.opy"
#!include "../ai/99-delimiter-end.opy"

# Hero gameplay rules
#!include "../../heroes/init.main.opy"

# Debug and changelog
#!include "../debug/10-debug-ultimate.opy"
#!include "../debug/20-changelog.opy"
#!include "../../utilities/changelog_text.opy"
