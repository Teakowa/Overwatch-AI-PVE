#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Wrecking Ball] Disable Adaptive Shield for allies":
    @Event eachPlayer
    @Hero wreckingBall
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingAbility2() == true
    @Disabled

    eventPlayer.disallowButton(Button.ABILITY_2)
    waitUntil(not eventPlayer.isUsingAbility2() or eventPlayer._reset_requested != false, 7)
    eventPlayer.allowButton(Button.ABILITY_2)
