#!include "constants/player_constants.opy"
#!include "modules/prelude/_index.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!postCompileHook "post-compile-hook.js"

#!include "modules/_index.opy"
