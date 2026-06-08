#!optimizeStrict

rule "[Winston]: Tesla Cannon Alt Fire":
    @Event playerDealtDamage
    @Hero winston
    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(victim, attacker, victim.getMaxHealth().scaledBy(WINSTON_SECONDARY_HEALTH_SCALAR))
    heal(attacker, attacker, eventDamage)
    wait()
