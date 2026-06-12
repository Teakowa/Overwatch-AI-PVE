#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Winston]: Tesla Cannon Alt Fire":
    @Event playerDealtDamage
    @Hero winston
    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(victim, attacker, victim.maxHealthPercent(WinstonBuff[0]))
    heal(attacker, attacker, eventDamage)
    wait()
