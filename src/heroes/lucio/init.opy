#!optimizeStrict

rule "[Lucio]: Detect switch to Lucio":
    @Event eachPlayer
    @Hero lucio

    eventPlayer.reset_pvar[0] = true

rule "[Lucio] Initialize":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["巴西拳王", "喇叭摩西", "轮滑摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false
