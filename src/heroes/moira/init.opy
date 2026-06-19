#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitMoira():
    @Name "[moira/init.opy]: heroInitMoira()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["五  金  上  将", "五金上将莫伊拉", "五金摩西", "生化摩西"]))
    lbl_0:
