#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitReinhardt():
    @Name "[reinhardt/init.opy]: heroInitReinhardt()"

    #eventPlayer.setKnockbackReceived(REINHARDT_INIT_KNOCKBACK_RECEIVED)
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["小米Su7 Ultra", "Hadi", "冲锋摩西", "抡锤摩西"]))
    lbl_0:
