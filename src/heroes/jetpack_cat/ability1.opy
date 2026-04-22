rule "[JetpackCat]: Frenetic Flight damage reduction":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.setDamageReceived(65)
    eventPlayer.setHealingDealt(150)
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setHealingDealt(100)
    wait(0.5)
