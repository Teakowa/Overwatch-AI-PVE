rule "[AI/control]: Hazard Primary":
    @Event eachPlayer
    @Team 1
    @Hero hazard
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
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
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.ABILITY_1)
    waitUntil(eventPlayer.getAltitude() > 0.1, 99999)
    waitUntil(eventPlayer.getAltitude() < 0.1, 99999)
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
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
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
    
    waitUntil(true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 25.5, 99999)
    eventPlayer.startForcingButton(Button.ULTIMATE)



