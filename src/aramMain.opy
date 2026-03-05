#!include "constants/player_constants.opy"
#!include "aram_settings.opy"
#!include "aram_protocol.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!postCompileHook "post-compile-hook.js"

#!include "aram_shared_index.opy"
#!include "aram_shared_utilities.opy"
#!include "modules/bootstrap/11-blacklist.opy"
#!include "aram_overrides.opy"
