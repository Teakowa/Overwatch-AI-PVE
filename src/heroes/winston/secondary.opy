#!optimizeStrict

rule "[Winston]: Tesla Cannon Alt Fire":
    @Event playerDealtDamage
    @Hero winston
    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(victim, attacker, victim.getMaxHealth() * 0.08)
    heal(attacker, attacker, eventDamage)
    wait()
