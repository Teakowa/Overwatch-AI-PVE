#!mainFile "../../aramMain.opy"
#!optimizeStrict

rule "[Juno]: Pulsar Torpedoes":
    @Event playerDealtDamage
    @Hero juno
    @Condition eventAbility == Button.SECONDARY_FIRE

    damage(victim, attacker, victim.maxHealthPercent(JUNO_SECONDARY_MAX_HEALTH_PERCENT))
    wait()
