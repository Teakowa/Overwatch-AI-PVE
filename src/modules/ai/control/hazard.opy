#!optimizeStrict

rule "[AI/control]: Hazard Primary":
    @Event eachPlayer
    @Team 1
    @Hero hazard
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



rule "[AI/control]: Hazard Secondary":
    @Event playerTookDamage
    @Team 1
    @Hero hazard
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(WAIT_AI_THROTTLE_MIN)
    wait(WAIT_AI_THROTTLE_MIN, Wait.RESTART_WHEN_TRUE)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)



rule "[AI/control]: Hazard Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero hazard
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) != true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true
    
    eventPlayer.startForcingButton(Button.ABILITY_1)
    waitUntil(eventPlayer.getAltitude() > 0.1, 1.25)
    waitUntil(eventPlayer.getAltitude() < 0.1, 2.5)
    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(WAIT_AI_THROTTLE_MIN)
    eventPlayer.stopForcingButton(Button.ABILITY_1)



rule "[AI/control]: Hazard Ability 2":
    @Event eachPlayer
    @Team 1
    @Hero hazard
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) != true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true
    
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(2)



rule "[AI/control]: Hazard Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero hazard
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    
    waitUntil(
        eventPlayer.botTarget != null and eventPlayer.botTarget.isAlive() == true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 25.5,
        5
    )
    eventPlayer.startForcingButton(Button.ULTIMATE)


