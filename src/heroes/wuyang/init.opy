#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitWuyang():
    @Name "[wuyang/init.opy]: heroInitWuyang()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["玩水摩西", "成都摩西"]))
    lbl_0:
