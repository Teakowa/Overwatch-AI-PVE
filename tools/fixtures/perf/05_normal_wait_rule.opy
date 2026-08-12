#!mainFile "../../main.opy"
#!optimizeStrict

rule "[fixture]: normal wait-based rule":
    @Event playerTookDamage
    @Team 1
    @Condition eventPlayer.isAlive() == true

    wait(2, Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
