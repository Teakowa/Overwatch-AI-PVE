#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitDmon():
    @Name "[dmon/init.opy]: heroInitDmon()"

    # Clear any stale shield-rush state from a previous life/hero switch.
    eventPlayer.dmon_dash_state[0] = false
    eventPlayer.dmon_dash_state[1] = false
