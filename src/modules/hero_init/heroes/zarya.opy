rule "[Zarya]: Detect switch to Zarya":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.reset_pvar[10] != eventPlayer.getHero()

    eventPlayer.reset_pvar[10] = eventPlayer.getHero()
    eventPlayer.reset_pvar[0] = true


rule "[Zarya] Initialize":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.zarya_buff[0] = true
    eventPlayer.custom_hp_pvar[0] = 200
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 200
    #applyCustomHp()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["Sinatraa", "泡泡摩西", "东北雨姐"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


