rule "[Wrecking Ball]: Detect switch to Wrecking Ball":
    @Event eachPlayer
    @Hero wreckingBall
    @Condition eventPlayer.reset_pvar[10] != eventPlayer.getHero()

    eventPlayer.reset_pvar[10] = eventPlayer.getHero()
    eventPlayer.reset_pvar[0] = true


rule "[Wrecking Ball] Initialize":
    @Event eachPlayer
    @Hero wreckingBall
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 500
    eventPlayer.custom_hp_pvar[1] = 100
    eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    #removeTankPassive()
    eventPlayer.reset_pvar[0] = false


