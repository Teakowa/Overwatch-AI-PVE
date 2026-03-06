rule "[Genji]: Deflect":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 2.192)
    eventPlayer.setDamageDealt(200)
    waitUntil(not eventPlayer.isUsingAbility2(), 3)
    eventPlayer.setDamageDealt(100)
