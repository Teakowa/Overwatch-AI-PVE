#!optimizeStrict

rule "[Juno]: Pulsar Torpedoes":
    @Event playerDealtDamage
    @Hero juno
    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(victim, attacker, victim.getMaxHealth().scaledBy(JUNO_SECONDARY_HEALTH_SCALAR))
    wait()
