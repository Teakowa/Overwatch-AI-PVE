#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitPharah():
    @Name "[pharah/init.opy]: heroInitPharah()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["飞天摩西", "只因摩西"]))
    lbl_0:
