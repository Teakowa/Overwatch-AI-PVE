rule "[Wuyang]: Ebb and Flow lost control":
    @Event playerReceivedKnockback
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker.getHero() == Hero.WUYANG
    
    victim.startForcingThrottle(0, 0, 0, 0, 0, 0)
    #victim.applyImpulse(Vector.UP, 1, Relativity.TO_PLAYER)
    #victim.setGravity(0)
    waitUntil(victim.hasStatus(Status.INVINCIBLE), 0.75)
    victim.stopForcingThrottle()
    #victim.setGravity(100)
