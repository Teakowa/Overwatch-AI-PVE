#!optimizeStrict

rule "[Emre/init.opy]: Detect switch to Emre":
    @Event eachPlayer
    @Hero emre

    eventPlayer.reset_pvar[0] = true

rule "[Emre/init.opy]: Initialize Emre":
    @Event eachPlayer
    @Hero emre
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["不是M", "天眼摩西", "丢雷摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false
