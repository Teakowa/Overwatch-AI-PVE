
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
    @Condition (len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) and distance(eventPlayer, player) <= 10])) >= 3
    #@Condition getPlayersInRadius(eventPlayer, 15, eventPlayer.getTeam(), LosCheck.SURFACES) >= 3
    @Condition (len([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player) and distance(eventPlayer, player) <= 15])) >= 3
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
    @Condition evalOnce(eventPlayer.isDummy()) != false
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
    
    wait(3.5, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.isOnObjective() == true:
        goto lbl_0
    eventPlayer.teleport(nearestWalkablePosition(eventPlayer.reset_pvar[15] - worldVector(vect(0, 0, -2), eventPlayer, Transform.ROTATION)))
    if ruleCondition:
        loop()
    lbl_0:


