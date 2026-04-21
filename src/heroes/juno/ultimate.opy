rule "[Juno] Track Orbital Ray Position":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isAlive() == true

    wait(0.5, Wait.ABORT_WHEN_FALSE)
    getPlayersInRadius(eventPlayer, 12.5, eventPlayer.getTeam()).juno_buff[0] = true
    wait(10)
    getPlayers(eventPlayer.getTeam()).juno_buff[0] = false
