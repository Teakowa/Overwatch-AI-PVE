#!optimizeStrict

rule "[JetpackCat]: Frenetic Flight damage reduction":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.setDamageReceived(JETPACK_CAT_ABILITY1_LINE_8_DAMAGE_RECEIVED)
    eventPlayer.setHealingDealt(JETPACK_CAT_ABILITY1_LINE_9_HEALING_DEALT)
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setHealingDealt(100)
    wait(0.5)
