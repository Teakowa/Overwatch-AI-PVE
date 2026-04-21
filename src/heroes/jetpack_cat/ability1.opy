rule "[JetpackCat]: Frenetic Flight damage reduction":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.setDamageReceived(65)
    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    eventPlayer.setDamageReceived(100)
    wait(0.5)
