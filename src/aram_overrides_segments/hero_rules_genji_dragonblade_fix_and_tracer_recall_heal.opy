rule "[Genji] Dragonblade Damage Fix":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setDamageDealt(100 + Genji[1])
    eventPlayer.setDamageReceived(90)
    waitUntil(not eventPlayer.isUsingUltimate(), 8)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setDamageReceived(100)

rule "[Genji]: Deflect":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 2.192)
    eventPlayer.setDamageDealt(200)
    waitUntil(not eventPlayer.isUsingAbility2(), 3)
    eventPlayer.setDamageDealt(100)

rule "[Tracer] Recall Healing":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.startHealingOverTime(null, 2, 25)

