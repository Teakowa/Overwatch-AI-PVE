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

    victim.startDamageOverTime(attacker, 2, victim.getMaxHealth() * 0.5 / 2)

    wait(5)

rule "[Ashe]: Dynamite cd":

    @Event playerDealtDamage

    @Hero ashe

    @Condition eventAbility == Button.ABILITY_2

    @Condition attacker != victim

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 1)

    wait(1)
