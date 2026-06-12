#!optimizeStrict

rule "[Hanzo]: headshot damage":
    @Event playerDealtDamage
    @Hero hanzo
    @Condition HeadshotDamage[3] > 0
    @Condition eventWasCriticalHit == true

    damage(victim, attacker, ceil(victim.maxHealthPercent(HeadshotDamage[3])))
    wait()
