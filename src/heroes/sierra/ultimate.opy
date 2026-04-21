rule "[Sierra]: ultmate stun":
    @Event playerDealtKnockback
    @Hero sierra
    @Condition eventAbility == Button.ULTIMATE

    victim.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 1.5)
    damage(victim, attacker, eventDamage / 2)
    wait(1.5)
