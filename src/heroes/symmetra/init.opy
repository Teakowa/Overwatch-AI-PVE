#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitSymmetra():
    @Name "[symmetra/init.opy]: heroInitSymmetra()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["我是杨幂", "杨幂", "烫头摩西"]))
    lbl_0:
    getPlayers(eventPlayer.getTeam()).reset_pvar[3] = eventPlayer
