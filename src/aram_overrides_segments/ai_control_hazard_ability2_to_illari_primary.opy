rule "[AI/control]: Hazard Ability 2":
    @Event eachPlayer
    @Team 1
    @Hero hazard
    @Condition evalOnce(eventPlayer.isDummy()) != false
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
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    
    waitUntil(true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 25.5, 99999)
    eventPlayer.startForcingButton(Button.ULTIMATE)

rule "[AI/control]: Illari Primary":
    @Event eachPlayer
    @Team 1
    @Hero illari
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    wait(0.9)
    if ruleCondition:
        loop()

