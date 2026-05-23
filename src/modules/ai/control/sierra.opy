#!optimizeStrict

rule "[AI/control]: Sierra Primary":
    @Event eachPlayer
    @Team 1
    @Hero sierra
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true

    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(max(getAverageServerLoad() / 1000, 1))
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)

rule "[AI/control]: Sierra Secondary":
    @Event eachPlayer
    @Team 1
    @Hero sierra
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true

    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    wait(3)

rule "[AI/control]: Sierra Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero sierra
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true

    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(0.8)
    eventPlayer.stopForcingButton(Button.ABILITY_1)
    wait(max(getAverageServerLoad() / 1000, 0.5))

rule "[AI/control]: Sierra Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero sierra
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true

    wait(random.uniform(1, 3))
    eventPlayer.startForcingButton(Button.ABILITY_1)
    if ruleCondition:
        loop()

rule "[AI/control]: Emre Ability 2":
    @Event eachPlayer
    @Team 1
    @Hero emre
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) != true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true

    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(1)
    eventPlayer.stopForcingButton(Button.ABILITY_2)

rule "[AI/control]: Sierra Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero sierra
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true

    waitUntil(
        eventPlayer.botTarget != null and eventPlayer.botTarget.isAlive() == true and isInLoS(eventPlayer, eventPlayer.botTarget) == true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 16,
        Math.INFINITY
    )
    eventPlayer.startForcingButton(Button.ULTIMATE)
    wait(0.8)
    eventPlayer.stopForcingButton(Button.ULTIMATE)
