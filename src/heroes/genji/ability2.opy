#!optimizeStrict

rule "[Genji]: Deflect":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingAbility2() == true

    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, GENJI_ABILITY2_INVINCIBLE_DURATION)
    eventPlayer.setDamageDealt(GENJI_ABILITY2_DAMAGE_DEALT)
    waitUntil(not eventPlayer.isUsingAbility2(), 3)
    eventPlayer.setDamageDealt(100)
