#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitRamattra():
    @Name "[ramattra/init.opy]: heroInitRamattra()"

    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["我 扛 不 住 辣", "鲑鱼大帝", "Suffer as i have!", "抱头摩西", "痛苦摩西"]))
    lbl_0:
