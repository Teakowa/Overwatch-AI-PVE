rule "[Illari]: Detect switch to Illari":
    @Event eachPlayer
    @Hero illari
    
    eventPlayer.reset_pvar[0] = true


rule "[Illari] Initialize":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer.reset_pvar[0] = false


