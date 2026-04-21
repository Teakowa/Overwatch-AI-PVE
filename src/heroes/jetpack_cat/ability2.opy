rule "[JetpackCat]: Purr cleanses negative statuses":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.isUsingAbility2() == true

    resetStatuses()
    waitUntil(not eventPlayer.isUsingAbility2(), 3)
