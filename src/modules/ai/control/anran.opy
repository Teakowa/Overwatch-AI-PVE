#!optimizeStrict

rule "[AI/control]: Anran Attack Pattern":
    @Event eachPlayer
    @Team 1
    @Hero anran
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true

    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(1.2, Wait.ABORT_WHEN_FALSE)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(0.6, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)

rule "[AI/control]: Anran Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero anran
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) > 8
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 24

    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.ABILITY_1)

rule "[AI/control]: Anran Ability 2":
    @Event eachPlayer
    @Team 1
    @Hero anran
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer, player) <= 8]) >= 2 or eventPlayer.getNormalizedHealth() < 0.45

    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.ABILITY_2)

rule "[AI/control]: Anran Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero anran
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.hasStatus(Status.BURNING) and distance(eventPlayer, player) <= 12]) > 0

    eventPlayer.forceButtonPress(Button.ULTIMATE)
