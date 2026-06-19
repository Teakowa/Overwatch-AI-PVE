#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitWinston():
    @Name "[winston/init.opy]: heroInitWinston()"

    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["电音王子吴亦凡", "雷电法王杨永信", "电击摩西", "菜就多练"]))
    lbl_0:
