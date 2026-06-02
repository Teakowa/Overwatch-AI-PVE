#!optimizeStrict

rule "[JetpackCat]: Frenetic Flight fuel regeneration":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) != true
    @Condition eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) < 100
    @Disabled

    wait(0.1)
    eventPlayer.setAbilityResource(Button.SECONDARY_FIRE, min(100, eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) + 7.5))
    if ruleCondition:
        loop()
