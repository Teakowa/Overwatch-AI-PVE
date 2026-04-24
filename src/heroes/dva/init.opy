#!optimizeStrict

rule "[D.Va]: Detect switch to D.Va":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.isInAlternateForm() == false

    eventPlayer.reset_pvar[0] = true

rule "[D.Va] Initialize":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    #removeTankPassive()
    eventPlayer.reset_pvar[0] = false
