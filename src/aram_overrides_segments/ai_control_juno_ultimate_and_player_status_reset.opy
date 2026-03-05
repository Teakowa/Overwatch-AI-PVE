rule "[AI/control]: Juno Ultimate":
    @Event playerTookDamage
    @Team 1
    @Hero juno
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    
    waitUntil(true and (((len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) and distance(eventPlayer, player) <= 10])) + (len([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player) and distance(eventPlayer, player) <= 15]))) >= 3), 99999)
    eventPlayer.forceButtonPress(Button.ULTIMATE)

rule "[Player]: status reset":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition (eventPlayer.hasStatus(Status.INVINCIBLE) or eventPlayer.hasStatus(Status.PHASED_OUT) or eventPlayer.unaffected == true) == true
    @Condition eventPlayer.mauga_berserker_soul != true
    
    resetStatuses()
    wait(1)

