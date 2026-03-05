#!include "constants/player_constants.opy"
#!include "modules/prelude/_index.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!postCompileHook "post-compile-hook.js"

#Blacklist module is loaded via modules/bootstrap/11-blacklist.opy in modules/_index.opy.
#!include "modules/_index.opy"
