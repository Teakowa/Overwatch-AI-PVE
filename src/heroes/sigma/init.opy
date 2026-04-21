rule "[Sigma]: Detect switch to Sigma":
    @Event eachPlayer
    @Hero sigma

    eventPlayer.reset_pvar[0] = true

rule "[Sigma] Initialize":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["核桃摩西", "长 者", "大爷摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false
