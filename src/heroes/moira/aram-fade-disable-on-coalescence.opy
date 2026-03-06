# moira aram-only fade disable on coalescence

rule "[Moira]: Fade disable on Coalescence":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingUltimate() == true
    @Disabled
    
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.disallowButton(Button.ABILITY_1)
    waitUntil(not eventPlayer.isUsingUltimate(), 9)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.setAbility1Enabled(true)
