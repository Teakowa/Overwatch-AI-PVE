rule "[Moira]: Fade disable on Coalescence":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.disallowButton(Button.ABILITY_1)
    waitUntil(not eventPlayer.isUsingUltimate(), 9)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.setAbility1Enabled(true)
rule "[Moira]: Abilities to heal self":
    @Event eachPlayer
    @Hero moira
    @Condition any([eventPlayer.isUsingAbility1(), eventPlayer.getAbilityCooldown(Button.ABILITY_2) >= 7.5, eventPlayer.isUsingUltimate()]) == true
    @Condition eventPlayer.getNormalizedHealth() < 1
    
    eventPlayer.startHealingOverTime(eventPlayer, 0.6, 0.75 * (eventPlayer.getMaxHealth() - eventPlayer.getHealth()))
    wait(WAIT_SHORT_FRAME)
