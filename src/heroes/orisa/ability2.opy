#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Orisa]: fly":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), ORISA_ABILITY2_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()
