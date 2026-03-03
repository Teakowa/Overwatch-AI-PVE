rule "[Juno]: Hyper Ring Max. range":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setProjectileSpeed(117.7)
    waitUntil(not eventPlayer.isUsingAbility2(), 5)
    eventPlayer.setProjectileSpeed(100)
rule "[Juno] Track Orbital Ray Position":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isAlive() == true
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    getPlayersInRadius(eventPlayer, 12.5, eventPlayer.getTeam()).juno_buff[0] = true
    wait(10)
    getPlayers(eventPlayer.getTeam()).juno_buff[0] = false
