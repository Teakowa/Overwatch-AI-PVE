rule "[Bot] PTP1":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition eventPlayer.hasStatus(Status.ASLEEP) == false
    @Condition eventPlayer.hasStatus(Status.ROOTED) == false
    @Condition eventPlayer.hasStatus(Status.KNOCKED_DOWN) == false
    @Condition (getCurrentMap() in [Map.ROUTE66, Map.HAVANA, Map.CIRCUIT_ROYAL, Map.DORADO, Map.JUNKERTOWN, Map.RIALTO, Map.SHAMBALI_MONASTERY] or getCurrentMap() in [Map.BLIZZ_WORLD, Map.BLIZZ_WORLD_WINTER, Map.EICHENWALDE, Map.EICHENWALDE_HALLOWEEN, Map.HOLLYWOOD, Map.HOLLYWOOD_HALLOWEEN, Map.KINGS_ROW, Map.KINGS_ROW_WINTER, Map.MIDTOWN, Map.NUMBANI, Map.PARAISO]) == true
    @Condition (isInLoS(eventPlayer, getPayloadPosition()) != true and getPlayersInRadius(eventPlayer, 37.5, Team.2, LosCheck.SURFACES) != true and len(getPlayersOnObjective(Team.2)) == 0 and eventPlayer.isUsingUltimate() != true) == true
    @Condition (eventPlayer.isAlive() and getPayloadProgressPercentage() >= 5 and distance(eventPlayer, getPayloadPosition()) >= 5 and distance(eventPlayer, getPayloadPosition()) < 20) == true

    wait(2, Wait.ABORT_WHEN_FALSE)
    eventPlayer.teleport(getPayloadPosition() + vect(random.uniform(0, 1.5), 1.5, random.uniform(0, 1.5)))
