#!mainFile "../../aramMain.opy"
#!optimizeStrict

# ashe aram-only headshot damage

rule "[Ashe]: Dynamite Damage":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker != victim

    victim.burn_stack += 3
    # damage(victim, attacker, victim.maxHealthPercent(ASHE_ARAM_MAX_HEALTH_PERCENT))
    victim.startDamageOverTime(attacker, ASHE_ARAM_DOT_DURATION, victim.maxHealthPercent(ASHE_ARAM_MAX_HEALTH_PERCENT))
    attacker.setAbilityCooldown(Button.ABILITY_2, attacker.getAbilityCooldown(Button.ABILITY_2).percentOf(50))
    wait(3)
