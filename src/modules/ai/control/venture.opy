#!optimizeStrict

rule "[AI/control]: Venture Primary":
    @Event eachPlayer
    @Team 1
    @Hero venture
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true
    
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)



rule "[AI/control]: Venture Secondary":
    @Event eachPlayer
    @Team 1
    @Hero venture
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true
    
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)



rule "[AI/control]: Venture Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero venture
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true
    
    eventPlayer.startForcingButton(Button.ABILITY_1)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget), 1, Relativity.TO_WORLD)
    wait(WAIT_AI_THROTTLE_MIN)
    eventPlayer.stopForcingButton(Button.ABILITY_1)
    wait(3.792)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(random.uniform(0.65, 1.3))
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    wait(0.624)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.startThrottleInDirection(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, eventPlayer.botTarget)) + eventPlayer.Strafe, 0), 1, Relativity.TO_WORLD)
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)



rule "[AI/control]: Venture Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero venture
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    
    waitUntil(
        eventPlayer.botTarget != null and eventPlayer.botTarget.isAlive() == true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 20,
        4
    )
    eventPlayer.startForcingButton(Button.ULTIMATE)


