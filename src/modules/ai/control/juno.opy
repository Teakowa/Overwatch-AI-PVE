#!optimizeStrict

rule "[AI/control]: Juno Primary":
    @Event eachPlayer
    @Team 1
    @Hero juno
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true
    
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    if eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) != 0:
        goto lbl_0
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(0.88)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    lbl_0:
    wait(random.uniform(1, 4))
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)



rule "[AI/control]: Juno Ability 2":
    @Event eachPlayer
    @Team 1
    @Hero juno
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true
    
    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(WAIT_AI_THROTTLE_MIN)
    eventPlayer.stopForcingButton(Button.ABILITY_2)



rule "[AI/control]: Juno Jump":
    @Event eachPlayer
    @Team 1
    @Hero juno
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == true
    
    eventPlayer.forceButtonPress(Button.JUMP)
    wait(0.5)
    eventPlayer.forceButtonPress(Button.JUMP)
    wait(WAIT_AI_THROTTLE_MIN)
    if eventPlayer.getAbilityCooldown(Button.ABILITY_1) != 0:
        goto lbl_0
    eventPlayer.startForcingButton(Button.ABILITY_1)
    waitUntil(not eventPlayer.isUsingAbility1(), 4)
    eventPlayer.stopForcingButton(Button.ABILITY_1)
    lbl_0:



rule "[AI/control]: Juno Ultimate":
    @Event playerTookDamage
    @Team 1
    @Hero juno
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    
    waitUntil(
        eventPlayer.botTarget != null and eventPlayer.botTarget.isAlive() == true and isInLoS(eventPlayer, eventPlayer.botTarget) == true and distance(eventPlayer, eventPlayer.botTarget) <= 10,
        4
    )
    eventPlayer.forceButtonPress(Button.ULTIMATE)


