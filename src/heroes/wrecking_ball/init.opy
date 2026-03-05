rule "[Wrecking Ball]: Detect switch to Wrecking Ball":
    @Event eachPlayer
    @Hero wreckingBall
    
    eventPlayer.reset_pvar[0] = true


rule "[Wrecking Ball] Initialize":
    @Event eachPlayer
    @Hero wreckingBall
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    #removeTankPassive()
    eventPlayer.reset_pvar[0] = false


