rule "[AI/control]: Tracer Ability 2":
    @Event playerTookDamage
    @Team 1
    @Hero tracer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isInSpawnRoom() != true
    
    waitUntil(eventPlayer.getNormalizedHealth() < 0.3, 3)
    eventPlayer.forceButtonPress(Button.ABILITY_2)



rule "[AI/control]: Tracer Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero tracer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    
    waitUntil(true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 2.6, 99999)
    eventPlayer.startForcingButton(Button.ULTIMATE)
    wait(3)
    eventPlayer.stopForcingButton(Button.ULTIMATE)



rule "[AI/control]: Tracer Primary":
    @Event eachPlayer
    @Team 1
    @Hero tracer
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition entityExists(eventPlayer.botTarget[0]) == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) != true
    @Condition isInLoS(eventPlayer.getEyePosition(), eventPlayer.botTarget[0].getEyePosition()) == true
    @Condition eventPlayer.botTarget != null
    #@Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(max(getAverageServerLoad() / 1000, 0.5))
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)



rule "[AI/control]: Tracer Recall (Remove Pluse Bomb)":
    @Event playerTookDamage
    @Team 1
    @Hero tracer
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker.getHero() == Hero.TRACER == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(max(getAverageServerLoad() / 1000, 0.1))



