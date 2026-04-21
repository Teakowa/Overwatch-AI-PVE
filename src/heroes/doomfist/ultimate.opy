rule "[Doomfist]: Meteor Strike":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.setDamageDealt(175 if eventPlayer.getTeam() == Team.1 else 150)
    waitUntil(not eventPlayer.isUsingUltimate(), 10)
    eventPlayer.setDamageDealt(100)
