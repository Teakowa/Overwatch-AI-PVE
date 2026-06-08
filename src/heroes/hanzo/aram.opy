#!optimizeStrict

rule "[Hanzo]: headshot damage":
    @Event playerDealtDamage
    @Hero hanzo
    # @Condition HeadshotDamage[3] > 2
    @Condition eventWasCriticalHit == true

    damage(victim, attacker, ceil(percentOf(8, victim.getMaxHealth())))
    wait()
