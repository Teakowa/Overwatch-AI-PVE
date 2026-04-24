#!optimizeStrict

rule "[Juno]: Detect switch to Juno":
    @Event eachPlayer
    @Hero juno

    eventPlayer.reset_pvar[0] = true

rule "[Juno] Initialize":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["轨投", "香香糯糯", "火星摩西", "大头摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer.reset_pvar[0] = false
