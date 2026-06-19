#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitHanzo():
    @Name "[hanzo/init.opy]: heroInitHanzo()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["ANS", "吃矢不忘拉矢人", "拉矢摩西", "贩箭摩西"]))
    lbl_0:
