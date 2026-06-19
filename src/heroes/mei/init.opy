#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitMei():
    @Name "[mei/init.opy]: heroInitMei()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["识得唔识得啊", "冰雕摩西", "麦克美", "周美玲冰雪大世界", "哈尔滨摩西"]))
    lbl_0:
