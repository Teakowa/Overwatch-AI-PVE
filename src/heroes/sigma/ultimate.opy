#!optimizeStrict

rule "[Sigma]: ult damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 75

    damage(victim, attacker, eventDamage / SIGMA_ULTIMATE_LINE_9_EVENT_DAMAGE_DIVISOR)
