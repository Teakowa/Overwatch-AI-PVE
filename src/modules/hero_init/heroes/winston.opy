rule "[winston/init.opy]: Detect switch to Winston":
    @Event eachPlayer
    @Hero winston
    
    eventPlayer.reset_pvar[0] = true


rule "[winston/init.opy]: Initialize Winston":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 300
    eventPlayer.custom_hp_pvar[1] = 200
    eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["电音王子吴亦凡", "雷电法王杨永信", "电击摩西", "菜就多练"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


