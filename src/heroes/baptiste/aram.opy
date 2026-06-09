#!mainFile "../../aramMain.opy"
#!optimizeStrict

# baptiste aram-only headshot damage

rule "[Baptiste]: headshot damage":
    @Event playerDealtDamage
    @Hero baptiste
    # @Condition HeadshotDamage[4] > 1
    @Condition eventWasCriticalHit == true
    @Condition eventAbility == Button.PRIMARY_FIRE

    damage(victim, attacker, ceil(eventDamage + victim.getMaxHealth().percentOf(6)))
