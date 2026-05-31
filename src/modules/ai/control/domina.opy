#!optimizeStrict

rule "[AI/control]: Domina Primary":
    @Event eachPlayer
    @Team 1
    @Hero domina
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true
    @Condition distance(eventPlayer, eventPlayer.botTarget) <= 25

    wait(0.032)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(1.2)
    waitUntil(any([eventPlayer.botTarget == null, eventPlayer.botTarget.isDead(), isInLoS(eventPlayer, eventPlayer.botTarget) != true, distance(eventPlayer, eventPlayer.botTarget) > 25]), Math.INFINITY)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)

rule "[AI/control]: Domina Secondary":
    @Event playerTookDamage
    @Team 1
    @Hero domina
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true

    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)

rule "[AI/control]: Domina Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero domina
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true

    waitUntil(
        eventPlayer.botTarget != null and eventPlayer.botTarget.isAlive() == true and distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 16,
        random.uniform(0.65, 1.2)
    )
    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.ABILITY_1)

rule "[AI/control]: Domina Ability 2":
    @Event eachPlayer
    @Team 1
    @Hero domina
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true
    @Condition distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) <= 14

    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.ABILITY_2)

rule "[AI/control]: Domina Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero domina
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true
    @Condition eventPlayer.botTarget.getNormalizedHealth() <= 0.45

    waitUntil(
        eventPlayer.botTarget != null and eventPlayer.botTarget.isAlive() == true and distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) <= 16,
        4
    )
    eventPlayer.forceButtonPress(Button.ULTIMATE)
