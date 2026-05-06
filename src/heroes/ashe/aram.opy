#!optimizeStrict

# ashe aram-only headshot damage

rule "[Ashe]: headshot damage":
    @Event playerDealtDamage
    @Hero ashe
    @Condition HeadshotDamage[1] > 1
    @Condition eventWasCriticalHit == true
    @Condition eventAbility != Button.ABILITY_1
    @Condition eventAbility != Button.ABILITY_2
    @Condition eventAbility != Button.ULTIMATE

    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[1] - 2)) / 2))

rule "[Ashe]: Dynamite Damage":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker != victim

    victim.burn_stack += 3
    damage(victim, attacker, victim.getMaxHealth() * 0.125)

rule "[Ashe]: Dynamite Burn Dot":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker != victim

    wait(1)
    damage(victim, attacker, victim.getMaxHealth() * 0.125)
    wait(5)

rule "[Ashe]: Dynamite cd":
    @Event playerDealtDamage
    @Hero ashe
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker != victim

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 1)
    wait(1)
