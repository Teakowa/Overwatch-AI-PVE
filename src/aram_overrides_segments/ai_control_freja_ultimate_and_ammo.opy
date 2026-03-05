rule "[AI/control]: Freja Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero freja
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    waitUntil(true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 18.6, 99999)
    eventPlayer.startForcingButton(Button.ULTIMATE)
    wait(3)
    eventPlayer.stopForcingButton(Button.ULTIMATE)

rule "[AI/control]: Freja Ammo":
    @Event eachPlayer
    @Team 1
    @Hero freja
    @Condition eventPlayer.getAmmo() <= 1
    #@Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2() or eventPlayer.isUsingUltimate()) == true
    
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())

