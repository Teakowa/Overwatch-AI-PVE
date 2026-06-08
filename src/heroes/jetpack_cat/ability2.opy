#!optimizeStrict

rule "[JetpackCat]: Purr cleanses negative statuses":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.isUsingAbility2() == true

    resetStatuses()
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, JETPACK_CAT_ABILITY2_LINE_9_INVINCIBLE_DURATION)
    eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, JETPACK_CAT_ABILITY2_LINE_10_PHASED_OUT_DURATION)
    wait(3)
