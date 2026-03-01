rule "[Ana]: Detect switch to Ana":
    @Event eachPlayer
    @Hero ana
    
    eventPlayer.reset_pvar[0] = true


rule "[Ana] Initialize":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 200
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["老年摩西", "睡觉摩西", "末日铁娜", "独眼摩西"]))
    eventPlayer.heroNum = BotHeroArray.index(eventPlayer.getHero())
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer.reset_pvar[0] = false


