#!mainFile "../../../main.opy"
#!optimizeStrict

rule "[AI/control]: Shion Primary":
    @Event eachPlayer
    @Team 1
    @Hero shion
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



rule "[AI/control]: Shion Secondary":
    @Event eachPlayer
    @Team 1
    @Hero shion
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true

    waitUntil(
        eventPlayer.botTarget != null and eventPlayer.botTarget.isAlive() == true and isInLoS(eventPlayer, eventPlayer.botTarget) == true and (eventPlayer.botTarget.getNormalizedHealth() <= 0.55 or distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) <= 14),
        0.35
    )
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(0.3)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    wait(max(getAverageServerLoad() / 1000, 0.4))



rule "[AI/control]: Shion Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero shion
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true

    waitUntil(
        eventPlayer.getNormalizedHealth() < 0.45 or (eventPlayer.botTarget != null and eventPlayer.botTarget.isAlive() == true and isInLoS(eventPlayer, eventPlayer.botTarget) == true and distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) <= 8),
        0.35
    )
    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.ABILITY_1)



rule "[AI/control]: Shion Ability 2":
    @Event eachPlayer
    @Team 1
    @Hero shion
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true

    waitUntil(
        eventPlayer.botTarget != null and eventPlayer.botTarget.isAlive() == true and isInLoS(eventPlayer, eventPlayer.botTarget) == true and distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) >= 7 and distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) <= 20,
        0.5
    )
    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(0.75)
    eventPlayer.stopForcingButton(Button.ABILITY_2)
    wait(max(getAverageServerLoad() / 1000, 0.35))
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(max(getAverageServerLoad() / 1000, 0.5))



rule "[AI/control]: Shion Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero shion
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true

    waitUntil(
        eventPlayer.botTarget != null and eventPlayer.botTarget.isAlive() == true and isInLoS(eventPlayer, eventPlayer.botTarget) == true and distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) <= 14,
        4
    )
    eventPlayer.startForcingButton(Button.ULTIMATE)
    wait(1.8)
    eventPlayer.stopForcingButton(Button.ULTIMATE)
