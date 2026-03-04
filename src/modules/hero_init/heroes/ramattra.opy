rule "[Ramattra]: Detect switch to Ramattra":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.reset_pvar[10] != eventPlayer.getHero()

    eventPlayer.reset_pvar[10] = eventPlayer.getHero()
    eventPlayer.reset_pvar[0] = true


rule "[Ramattra] Initialize":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 275
    eventPlayer.custom_hp_pvar[1] = 100
    eventPlayer.custom_hp_pvar[2] = 0
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["我 扛 不 住 辣", "鲑鱼大帝", "Suffer as i have!", "抱头摩西", "痛苦摩西"]))
    lbl_0:
    #applyCustomHp()
    eventPlayer.reset_pvar[0] = false


