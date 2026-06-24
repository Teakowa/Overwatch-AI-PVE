#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitWidowmaker():
    @Name "[widowmaker/init.opy]: heroInitWidowmaker()"

    eventPlayer.setMaxAmmo(0, 25)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["ANS", "亿枪一个", "KAI了就是KAI了？", "女兵摩西", "没关"]))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
