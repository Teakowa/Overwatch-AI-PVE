rule "[JetpackCat]: Purr cleanses negative statuses":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.isUsingAbility2() == true

    resetStatuses()
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 0.5)
    eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, 0.5)
    wait(3)
