#!optimizeStrict

# ashe aram-only headshot damage

rule "[Ashe]: Dynamite Damage":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker != victim

    victim.burn_stack += 3
    damage(victim, attacker, victim.getMaxHealth() * 0.125)
    wait(3)

rule "[Ashe]: Dynamite cd":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker != victim

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 1)
    wait(1)
