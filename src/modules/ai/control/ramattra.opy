#!optimizeStrict

rule "[AI/control]: Ramattra Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero ramattra
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition (not eventPlayer.getAbilityCooldown(Button.ABILITY_1)) == true
    @Condition (not eventPlayer.isUsingAbility1()) == true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) <= 10
    @Condition (not eventPlayer.isUsingUltimate()) == true
    
    eventPlayer.startForcingButton(Button.ABILITY_1)
    #wait(WAIT_AI_THROTTLE_MIN)
    #eventPlayer.stopForcingButton(Button.ABILITY_1)



rule "[AI/control]: Ramattra Ability 2":
    @Event playerTookDamage
    @Team 1
    @Hero ramattra
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition any([i == true for i in [eventPlayer.isUsingAbility1(), eventPlayer.isUsingUltimate()]]) == true
    
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    #wait(WAIT_AI_THROTTLE_MIN)
    #eventPlayer.stopForcingButton(Button.ABILITY_1)
    if eventPlayer.isUsingAbility1() == true:
        waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    else:
        waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)



