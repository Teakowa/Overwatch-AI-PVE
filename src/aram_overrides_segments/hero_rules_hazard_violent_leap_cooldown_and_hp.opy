rule "[Hazard]: Violent Leap kiil reset cooldown":
    @Event playerEarnedElimination
    @Hero hazard
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)

rule "[Hazard]: Violent Leap HP":
    @Event eachPlayer
    @Hero hazard
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 3
    
    if eventPlayer.hazard_hp_id == null:
        goto lbl_0
    removeHealthPool(eventPlayer.hazard_hp_id)
    lbl_0:
    eventPlayer.addHealthPool(Health.NORMAL, 125, false, false)
    eventPlayer.hazard_hp_id = getLastCreatedHealthPool()
    wait(3, Wait.RESTART_WHEN_TRUE)
    removeHealthPool(eventPlayer.hazard_hp_id)
    eventPlayer.hazard_hp_id = null

