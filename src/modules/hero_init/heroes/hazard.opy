rule "[Hazard/init.opy]: Detect switch to Hazard":
    @Event eachPlayer
    @Hero hazard
    @Condition eventPlayer.reset_pvar[10] != eventPlayer.getHero()

    eventPlayer.reset_pvar[10] = eventPlayer.getHero()
    eventPlayer.reset_pvar[0] = true


rule "[Hazard/init.opy]: Initialize Hazard":
    @Event eachPlayer
    @Hero hazard
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 200
    eventPlayer.custom_hp_pvar[1] = 250
    eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    #removeTankPassive()
    eventPlayer.reset_pvar[0] = false


