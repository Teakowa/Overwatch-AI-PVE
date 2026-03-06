rule "[Hazard]: Spike Guard using tracking":
    @Event eachPlayer
    @Hero hazard
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    eventPlayer.hazard_using_ability_sec = true
    waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 12)
    eventPlayer.hazard_using_ability_sec = false
