#!optimizeStrict

rule "[Hanzo]: headshot damage":
    @Event playerDealtDamage
    @Hero hanzo
    # @Condition HeadshotDamage[3] > 2
    @Condition eventWasCriticalHit == true

    damage(victim, attacker, ceil((victim.getMaxHealth() * 0.08)))
    wait()
