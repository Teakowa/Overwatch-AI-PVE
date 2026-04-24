#!optimizeStrict

rule "[Echo]: Focusing Beam Damage":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingAbility2() == true

    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setDamageDealt(150)
    waitUntil(not eventPlayer.isUsingAbility2(), 2)
    eventPlayer.setDamageDealt(100)
