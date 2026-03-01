rule "[Mei]: Detect switch to Mei":
    @Event eachPlayer
    @Hero mei
    
    eventPlayer.reset_pvar[0] = true


rule "[Mei] Initialize":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 275
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["识得唔识得啊", "冰雕摩西", "麦克美", "周美玲冰雪大世界", "哈尔滨摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


