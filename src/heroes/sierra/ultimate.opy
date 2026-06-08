#!optimizeStrict

rule "[Sierra]: ultmate stun":
    @Event playerDealtKnockback
    @Hero sierra
    @Condition eventAbility == Button.ULTIMATE

    victim.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, SIERRA_ULTIMATE_LINE_8_KNOCKED_DOWN_DURATION)
    damage(victim, attacker, eventDamage / SIERRA_ULTIMATE_LINE_9_EVENT_DAMAGE_DIVISOR)
    wait(1.5)
