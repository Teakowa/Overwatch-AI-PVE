#!optimizeStrict

rule "[Juno]: Hyper Ring Max. range":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer.isUsingAbility2() == true
    @Disabled

    eventPlayer.setProjectileSpeed(JUNO_ABILITY2_LINE_9_PROJECTILE_SPEED)
    waitUntil(not eventPlayer.isUsingAbility2(), 5)
    eventPlayer.setProjectileSpeed(100)
