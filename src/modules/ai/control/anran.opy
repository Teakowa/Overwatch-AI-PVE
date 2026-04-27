#!optimizeStrict

rule "[AI/control]: Anran Attack Pattern":
    @Event eachPlayer
    @Team 1
    @Hero anran
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true

    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(getAverageServerLoad() / 1000 * 1.2)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(getAverageServerLoad() / 1000 * 0.6)
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)

rule "[AI/control]: Anran Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero anran
    @Condition (eventPlayer.isDummy() != false and eventPlayer.isAlive()) == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    
    @Condition distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 24

    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.ABILITY_1)

rule "[AI/control]: Anran Ability 2":
    @Event eachPlayer
    @Team 1
    @Hero anran
    @Condition (eventPlayer.isDummy() != false and eventPlayer.isAlive()) == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
   

    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.ABILITY_2)

rule "[AI/control]: Anran Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero anran
    @Condition (eventPlayer.isDummy() != false and eventPlayer.isAlive()) == true
    @Condition eventPlayer.getUltCharge() == 100

    waitUntil(true and (len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.hasStatus(Status.BURNING) and distance(eventPlayer, player) <= 12]) > 0), Math.INFINITY)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.stopForcingButton(Button.ULTIMATE)

rule "[AI/control]: Anran Ultimate":
    @Event playerDied
    @Team 1
    @Hero anran
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.getUltCharge() == 100

    eventPlayer.forceButtonPress(Button.ULTIMATE)
    waitUntil(eventPlayer.isAlive() or eventPlayer.getUltCharge() != 100, Math.INFINITY)
    eventPlayer.stopForcingButton(Button.ULTIMATE)