#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitLucio():
    @Name "[lucio/init.opy]: heroInitLucio()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["巴西拳王", "喇叭摩西", "轮滑摩西"]))
    lbl_0:
