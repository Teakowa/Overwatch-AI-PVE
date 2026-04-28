#!optimizeStrict

rule "[AI/control]: Sojourn Ability 1":
    @Event playerTookDamage
    @Team 1
    @Hero sojourn
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.isAlive() == true
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer, player) <= 22]) > 0
    
    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(0.75)
    eventPlayer.stopForcingButton(Button.ABILITY_1)
    eventPlayer.forceButtonPress(Button.JUMP)
    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    wait(0.25)


