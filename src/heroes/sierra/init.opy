#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitSierra():
    @Name "[sierra/init.opy]: heroInitSierra()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["拉西", "无人机摩西"]))
    lbl_0:
