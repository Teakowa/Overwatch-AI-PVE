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

    if eventPlayer.botTarget == null:
        goto lbl_0
    if eventPlayer.botTarget.isAlive() != true:
        goto lbl_0
    if isInLoS(eventPlayer, eventPlayer.botTarget) != true:
        goto lbl_0
    if eventPlayer.botTarget.getNormalizedHealth() > 0.55 and distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) > 14:
        goto lbl_0
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(0.3)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    lbl_0:
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

    if eventPlayer.getNormalizedHealth() >= 0.45:
        if eventPlayer.botTarget == null:
            goto lbl_0
        if eventPlayer.botTarget.isAlive() != true:
            goto lbl_0
        if isInLoS(eventPlayer, eventPlayer.botTarget) != true:
            goto lbl_0
        if distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) > 8:
            goto lbl_0
    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.ABILITY_1)
    lbl_0:



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

    if eventPlayer.botTarget == null:
        goto lbl_0
    if eventPlayer.botTarget.isAlive() != true:
        goto lbl_0
    if isInLoS(eventPlayer, eventPlayer.botTarget) != true:
        goto lbl_0
    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(0.75)
    # eventPlayer.stopForcingButton(Button.ABILITY_2)
    wait(random.uniform(1.67, 3))
    # eventPlayer.forceButtonPress(Button.ABILITY_2)
    eventPlayer.stopForcingButton(Button.ABILITY_2)
    lbl_0:
    wait(max(getAverageServerLoad() / 1000, 0.5))



rule "[AI/control]: Shion Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero shion
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
	@Condition eventPlayer.isUsingUltimate() != true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true

    waitUntil(
        eventPlayer.botTarget != null and eventPlayer.botTarget.isAlive() == true and isInLoS(eventPlayer, eventPlayer.botTarget) == true and distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) <= 14,
        Math.INFINITY
    )
    eventPlayer.startForcingButton(Button.ULTIMATE)
    wait(1.8)
    eventPlayer.stopForcingButton(Button.ULTIMATE)
