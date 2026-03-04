rule "[roadhog]: Detect switch to roadhog":
    @Event eachPlayer
    @Hero roadhog
    
    eventPlayer.reset_pvar[0] = true


rule "[roadhog]":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 700
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    eventPlayer.setMaxAmmo(0, 5)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
    eventPlayer.startForcingName(random.choice(["链钩摩西", "肥猪摩西", "小鱿摩西", "奶霸摩西"]))
    #removeTankPassive()
    eventPlayer.reset_pvar[0] = false

