#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitBastion():
    @Name "[bastion/init.opy]: heroInitBastion()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["电脑", "嘟嘟嘟嘟嘟", "大炮摩西", "无可奉告"]))
    lbl_0:
