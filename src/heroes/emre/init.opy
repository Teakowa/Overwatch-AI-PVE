#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitEmre():
    @Name "[emre/init.opy]: heroInitEmre()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["不是M", "天眼摩西", "丢雷摩西"]))
    lbl_0:
