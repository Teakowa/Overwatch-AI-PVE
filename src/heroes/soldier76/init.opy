#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitSoldier76():
    @Name "[soldier76/init.opy]: heroInitSoldier76()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["国服顶尖小巴蒂", "跑男摩西", "奶棒摩西", "Kai了", "飞弹摩西"]))
    lbl_0:
