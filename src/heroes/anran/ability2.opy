#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Anran]: Ability 2":
    @Event eachPlayer
    @Hero anran
    @Condition eventPlayer.isUsingAbility2() == true

    wait()
    resetStatuses()
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, ANRAN_ABILITY2_PHASED_OUT_DURATION)
    eventPlayer.unaffected = true
    waitUntil(not eventPlayer.isUsingAbility2(), 2.5)
    wait(0.8)
    eventPlayer.unaffected = false
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    wait(4)
