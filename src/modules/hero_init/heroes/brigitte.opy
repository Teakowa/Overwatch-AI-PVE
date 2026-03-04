rule "[Brigitte]: Detect switch to Brigitte":
    @Event eachPlayer
    @Hero brigitte
    
    eventPlayer.reset_pvar[0] = true


rule "[Brigitte] Initialize":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 200
    eventPlayer.custom_hp_pvar[1] = 75
    eventPlayer.custom_hp_pvar[2] = 0
    #eventPlayer.setMaxHealth(41.667)
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["那个女人", "炖鸡摩西", "持盾摩西", "贴膜摩西", "护 娜 十 三 锤", "泰格"]))
    lbl_0:
    getPlayers(eventPlayer.getTeam()).reset_pvar[1] = eventPlayer
    eventPlayer.reset_pvar[0] = false

