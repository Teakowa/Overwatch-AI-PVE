#!mainFile "../../../aramMain.opy"
#!optimizeStrict


rule "[AI/global]: Generated at the beginning":
    @Condition any([isWaitingForPlayers(), isInSetup(), isGameInProgress()]) == true
    @Condition getPlayersOnHero(CustomAIArray[CustomAI], Team.1).hasSpawned() != true
    
    wait(getAverageServerLoad() / 100)
    #waitUntil(getPlayersOnHero(CustomAIArray[CustomAI], Team.1).hasSpawned() != true, 9999)
    destroyAllDummies()
    wait(0.25)
    createDummy(CustomAIArray[CustomAI], Team.1, -1, nearestWalkablePosition(random.choice(getLivingPlayers(Team.1)).getPosition() + vect(random.uniform(-1, 1), random.uniform(-1, 1), random.uniform(-1, 1)) * random.uniform(7, 10)))


rule "[AI/global]: Per second healing":
    @Event eachPlayer
    @Team 1
    @Condition isGameInProgress() == true
    
    eventPlayer.startHealingOverTime(eventPlayer, 3600, 8)


rule "[AI/global]: Counter Heros":
    Counters = [Hero.HAZARD, Hero.DVA, Hero.HANZO, Hero.SOLDIER, Hero.ORISA, Hero.TORBJORN, Hero.DOOMFIST, Hero.ZARYA, Hero.REAPER, Hero.PHARAH, Hero.GENJI, Hero.TRACER, Hero.WRECKING_BALL, Hero.MEI, Hero.ASHE, Hero.REINHARDT, Hero.SIGMA, Hero.CASSIDY, Hero.SOMBRA, Hero.ILLARI, Hero.RAMATTRA, Hero.JUNKER_QUEEN, Hero.WINSTON, Hero.SOJOURN]
    Counter_Bot = [Hero.ROADHOG, Hero.CASSIDY, Hero.MEI, Hero.ASHE, Hero.SOJOURN, Hero.LUCIO, Hero.ZENYATTA, Hero.BRIGITTE, Hero.KIRIKO, Hero.ILLARI, Hero.HAZARD, Hero.JUNO, Hero.FREJA, Hero.SOMBRA, Hero.SYMMETRA]


rule "[AI/ultimate]: Counter Ultimate Ability":
    @Event playerTookDamage
    @Team 1
    @Condition eventAbility == Button.ULTIMATE
    @Condition victim.getHero() in Counter_Bot == true
    @Condition attacker.getHero() in Counters == true
    @Condition attacker.isUsingUltimate() != true
    @Condition (eventPlayer.isAlive() and eventPlayer.getUltCharge() == 100) == true
    
    eventPlayer.startForcingButton(Button.ULTIMATE)
    wait(2)
    eventPlayer.stopForcingButton(Button.ULTIMATE)


rule "[AI/ultimate]: Auto use Ultimate Ability":
    @Event playerTookDamage
    @Team 1
    #@Condition getPlayersInRadius(eventPlayer, 10, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES) >= 3
    @Condition len(getPlayersInRadius(eventPlayer, 10, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES)) >= 3
    #@Condition getPlayersInRadius(eventPlayer, 15, eventPlayer.getTeam(), LosCheck.SURFACES) >= 3
    @Condition len(getPlayersInRadius(eventPlayer, 15, eventPlayer.getTeam(), LosCheck.SURFACES)) >= 3
    @Condition victim.getHero() in Counter_Bot == false
    @Condition (eventPlayer.isAlive() and eventPlayer.getUltCharge() == 100) == true
    
    eventPlayer.startForcingButton(Button.ULTIMATE)
    wait(0.34)
    eventPlayer.stopForcingButton(Button.ULTIMATE)


rule "[AI/ultimate]: Auto charge Ultimate":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.getUltCharge() >= 95 == true
    
    eventPlayer.setUltCharge(100)


rule "[AI/global]: TP":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.reset_pvar[15].isAlive() == true
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition eventPlayer.hasStatus(Status.ASLEEP) == false
    @Condition eventPlayer.hasStatus(Status.ROOTED) == false
    @Condition eventPlayer.hasStatus(Status.KNOCKED_DOWN) == false
    @Condition eventPlayer.hazard_using_ability_sec != true
    @Condition (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire() or eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2() or eventPlayer.isUsingUltimate()) != true
    @Condition (distance(eventPlayer, eventPlayer.reset_pvar[15]) >= 2.5 or not isInLoS(eventPlayer, eventPlayer.reset_pvar[15])) == true
    @Condition (not eventPlayer.isOnObjective() or not eventPlayer.isInSpawnRoom()) == true
    
    wait(4, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.isOnObjective() == true:
        goto lbl_0
    eventPlayer.teleport(nearestWalkablePosition(eventPlayer.reset_pvar[15] - worldVector(vect(0, 0, -2), eventPlayer, Transform.ROTATION)))
    if ruleCondition:
        loop()
    lbl_0:


rule "[Bot] ACC":
    @Event eachPlayer
    @Team 1
    @Condition getMatchTime() == 0
    @Condition (getCurrentMap() in [Map.ROUTE66, Map.HAVANA, Map.CIRCUIT_ROYAL, Map.DORADO, Map.JUNKERTOWN, Map.RIALTO, Map.SHAMBALI_MONASTERY] or getCurrentMap() in [Map.BLIZZ_WORLD, Map.BLIZZ_WORLD_WINTER, Map.EICHENWALDE, Map.EICHENWALDE_HALLOWEEN, Map.HOLLYWOOD, Map.HOLLYWOOD_HALLOWEEN, Map.KINGS_ROW, Map.KINGS_ROW_WINTER, Map.MIDTOWN, Map.NUMBANI, Map.PARAISO]) == true
    @Condition (isInLoS(eventPlayer, getPayloadPosition()) and eventPlayer.isAlive() and len(getPlayersOnObjective(Team.2)) >= 1 and len(getPlayersOnObjective(Team.1)) < 3 and getPayloadProgressPercentage() >= 2.5 and distance(eventPlayer, getPayloadPosition()) >= 2.5 and distance(eventPlayer, getPayloadPosition()) < 25) == true

    eventPlayer.startAcceleration(directionTowards(eventPlayer, getPayloadPosition()), 80, 3, Relativity.TO_WORLD)
    wait(2)
    if ruleCondition:
        loop()
    eventPlayer.stopAcceleration()

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
