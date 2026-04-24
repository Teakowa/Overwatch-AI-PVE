#!optimizeStrict

rule "[Juno]: Hyper Ring Max. range":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer.isUsingAbility2() == true

    eventPlayer.setProjectileSpeed(117.7)
    waitUntil(not eventPlayer.isUsingAbility2(), 5)
    eventPlayer.setProjectileSpeed(100)
