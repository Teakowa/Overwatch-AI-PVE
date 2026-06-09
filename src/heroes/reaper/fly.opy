#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Reaper]: Wraith Form to fly":
    @Event eachPlayer
    @Hero reaper
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    eventPlayer.applyImpulse(Vector.UP, REAPER_FLY_UPWARD_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.2)
    if ruleCondition:
        loop()

rule "[Reaper]: Wraith Form to fly":
    @Event eachPlayer
    @Hero reaper
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true

    eventPlayer.applyImpulse(Vector.DOWN, REAPER_FLY_DOWNWARD_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.2)
    if ruleCondition:
        loop()