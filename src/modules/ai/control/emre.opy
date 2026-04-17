rule "[AI/control]: Emre Primary":
    @Event eachPlayer
    @Team 1
    @Hero emre
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0

    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN), Wait.ABORT_WHEN_FALSE)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)

rule "[AI/control]: Emre Secondary":
    @Event playerTookDamage
    @Team 1
    @Hero emre
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0

    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)

rule "[AI/control]: Emre Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero emre
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0

    waitUntil(true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 6.8, random.uniform(0.65, 1.2))
    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.ABILITY_1)

rule "[AI/control]: Emre Ability 2":
    @Event eachPlayer
    @Team 1
    @Hero emre
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) != true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0

    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(1)
    eventPlayer.stopForcingButton(Button.ABILITY_2)

rule "[AI/control]: Emre Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero emre
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true

    waitUntil(true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 16 or eventPlayer.isInAir(), 99999)
    resetStatuses()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    wait(random.uniform(2, 4))
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
