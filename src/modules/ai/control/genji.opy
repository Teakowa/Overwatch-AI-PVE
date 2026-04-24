#!optimizeStrict

rule "[AI/control]: Genji Ability 2":
    @Event playerTookDamage
    @Team 1
    @Hero genji
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    #@Condition eventPlayer.isUsingAbility2() == true
    #@Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    wait()
    if len(eventPlayer.botTemp) <= 0:
        goto lbl_0
    botAim2Target()
    lbl_0:
    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(2)
    eventPlayer.stopFacing()
    eventPlayer.stopForcingButton(Button.ABILITY_2)



rule "[AI/control]: Genji Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero genji
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(0.5)
    if ruleCondition:
        loop()



