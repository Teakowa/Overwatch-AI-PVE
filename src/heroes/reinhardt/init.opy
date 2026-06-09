#!mainFile "../../main.opy"
#!optimizeStrict

rule "[reinhardt/init.opy]: Detect switch to Reinhardt":
    @Event eachPlayer
    @Hero reinhardt

    eventPlayer.reset_pvar[0] = true

rule "[reinhardt/init.opy]: Initialize Reinhardt":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    #eventPlayer.setKnockbackReceived(REINHARDT_INIT_KNOCKBACK_RECEIVED)
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["小米Su7 Ultra", "Hadi", "冲锋摩西", "抡锤摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false
