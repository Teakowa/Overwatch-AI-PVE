rule "[Sigma]: Detect switch to Sigma":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.reset_pvar[10] != eventPlayer.getHero()

    eventPlayer.reset_pvar[10] = eventPlayer.getHero()
    eventPlayer.reset_pvar[0] = true


rule "[Sigma] Initialize":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 200
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 200
    #applyCustomHp()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["核桃摩西", "长 者", "大爷摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


