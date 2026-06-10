#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Winston]: Tesla Cannon Alt Fire":
    @Event playerDealtDamage
    @Hero winston
    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(victim, attacker, victim.maxHealthPercent(WINSTON_SECONDARY_MAX_HEALTH_PERCENT))
    heal(attacker, attacker, eventDamage)
    wait()
