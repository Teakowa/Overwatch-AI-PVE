#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitWinston():
    @Name "[winston/init.opy]: heroInitWinston()"

    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["雷电法王杨永信", "电击摩西", "络腮胡摩西"]))
    lbl_0:
