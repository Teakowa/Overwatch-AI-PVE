rule "[AI/control]: Reaper Primary":
    @Event eachPlayer
    @Team 1
    @Hero reaper
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.botTarget != null
    
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)


rule "[AI/control]: Reaper Secondary":
    @Event eachPlayer
    @Team 1
    @Hero reaper
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    wait(3)



rule "[AI/control]: Reaper Ability 1":
    @Event playerTookDamage
    @Team 1
    @Hero reaper
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 3
    @Condition eventPlayer.botTarget != null
    
    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(0.4)
    waitUntil(distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 2.6, 3)
    eventPlayer.cancelPrimaryAction()
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 8)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    wait(0.4)
    eventPlayer.setPrimaryFireEnabled(true)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(WAIT_AI_THROTTLE_MIN)
    if ruleCondition:
        loop()



rule "[AI/control]: Reaper Ability 2":
    @Event eachPlayer
    @Team 1
    @Hero reaper
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 3
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.botTarget != null
    @Condition distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) > 5
    
    eventPlayer.startForcingButton(Button.ABILITY_2)
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)), 10000)
    wait(WAIT_AI_THROTTLE_MIN)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()), 10000)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(WAIT_AI_THROTTLE_MIN)
    if ruleCondition:
        loop()



rule "[AI/control]: Reaper Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero reaper
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true
    @Condition distance(eventPlayer, eventPlayer.botTarget) <= 8.3
    @Condition not eventPlayer.isFiringPrimaryFire()
    
    eventPlayer.startForcingButton(Button.ULTIMATE)
    waitUntil(not eventPlayer.isUsingUltimate(), 3.5)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(WAIT_AI_THROTTLE_MIN)
    if ruleCondition:
        loop()
