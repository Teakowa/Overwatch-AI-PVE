rule "[reset.opy]: Reinitialize hero on new round":
    @Event eachPlayer
    @Condition isMatchBetweenRounds() == true
    @Condition eventPlayer.getHero() != Hero.SOMBRA
    
    BOOTSTRAP_PLAYER_REINITIALIZE_BEFORE_WAIT_UNTIL()
    waitUntil(not isMatchBetweenRounds(), Math.INFINITY)
    BOOTSTRAP_PLAYER_REINITIALIZE_AFTER_WAIT_UNTIL()
    wait(1)
    resetHero()
    eventPlayer.reset_pvar[0] = true
    logToInspector("called init after new round")
