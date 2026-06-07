#!optimizeStrict

# ashe aram-only headshot damage

rule "[Ashe]: Dynamite Damage":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker != victim

    victim.burn_stack += 3
    # damage(victim, attacker, victim.getMaxHealth() * 0.125)
    victim.startDamageOverTime(attacker, 3, victim.getMaxHealth() * 0.125)
    attacker.setAbilityCooldown(Button.ABILITY_2, attacker.getAbilityCooldown(Button.ABILITY_2) * 0.5)
    wait(3)
