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

rule "[Wuyang]: Ebb and Flow set":
    @Event playerReceivedKnockback
    #@Condition eventPlayer.isUsingAbility2() == true
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker.getHero() == Hero.WUYANG

    victim.wuyang_buff[2]++
    #eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 1)
    wait(WAIT_SHORT_FRAME)
