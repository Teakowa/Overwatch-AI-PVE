rule "[Lifeweaver]: Detect switch to Lifeweaver":
    @Event eachPlayer
    @Hero lifeweaver
    
    eventPlayer.reset_pvar[0] = true


rule "[Lifeweaver] Initialize":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 175
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 75
    #applyCustomHp()
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer.reset_pvar[0] = false


