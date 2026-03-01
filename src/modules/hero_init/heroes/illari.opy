rule "[Illari]: Detect switch to Illari":
    @Event eachPlayer
    @Hero illari
    
    eventPlayer.reset_pvar[0] = true


rule "[Illari] Initialize":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 200
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer.reset_pvar[0] = false


