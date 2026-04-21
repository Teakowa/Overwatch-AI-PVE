rule "[Sombra] TP to Support":
    @Event eachPlayer
    @Team 1
    @Hero sombra
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isFiringSecondaryFire() == false
    @Condition eventPlayer.isFiringPrimaryFire() == false
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) != 0
    @Condition (eventPlayer.reset_pvar[9][0].isAlive() and not eventPlayer.reset_pvar[9][0].isInSpawnRoom()) == true
    @Condition (not eventPlayer.isOnObjective() or not eventPlayer.isInSpawnRoom()) == true
    @Condition distance(eventPlayer, eventPlayer.reset_pvar[9][0]) >= 5.5
    @Condition distance(getClosestPlayer(eventPlayer, eventPlayer.getTeam()), eventPlayer.reset_pvar[9][0]) <= 30

    wait(2, Wait.ABORT_WHEN_FALSE)
    eventPlayer.teleport(nearestWalkablePosition(eventPlayer.reset_pvar[9][0] - worldVector(vect(0, 0, -7), eventPlayer, Transform.ROTATION)))
    eventPlayer.startFacing(vectorTowards(updateEveryFrame(eventPlayer.getEyePosition()), ((sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer.getEyePosition(), player.getEyePosition()) == true], lambda i: distance(eventPlayer.getEyePosition(), i.getEyePosition())))[0]).getEyePosition()), 10000)
    waitUntil(not eventPlayer.reset_pvar[4].reset_pvar[9][0].isAlive(), 2)
    eventPlayer.stopFacing()
    wait(3)
