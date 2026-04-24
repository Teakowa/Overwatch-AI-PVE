#!optimizeStrict

rule "[AI/control]: Mauga Secondary":
    @Event eachPlayer
    @Team 1
    @Hero mauga
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer, player) <= 10]) > 0
    @Disabled
    
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    waitUntil(distance(eventPlayer.getPosition(), eventPlayer.botTarget) > 10 or len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer, player) <= 10]) == 0, 99999)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)



rule "[AI/control]: Mauga Ability 2":
    @Event playerTookDamage
    @Team 1
    @Hero mauga
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) < 0.5
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getNormalizedHealth() < 0.5
    
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(3)



