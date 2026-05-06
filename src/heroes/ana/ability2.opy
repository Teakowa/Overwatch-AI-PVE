#!optimizeStrict

rule "[Ana] Biotic Grenade Hit":
    @Event playerTookDamage
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker.getHero() == Hero.ANA == true
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true

    if victim.zarya_buff[1] != null:
        goto lbl_0
    eventPlayer.setStatusEffect(attacker, Status.BURNING, 3)
    eventPlayer.burn_stack += 3
    damage(eventPlayer, attacker, ceil(Ana_GrenadeDamage[0] / 100 * victim.getMaxHealth()))
    lbl_0:

rule "[Ana] Biotic Grenade Burn Dot":
    @Event playerTookDamage
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker.getHero() == Hero.ANA == true
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true

    if victim.zarya_buff[1] != null:
        goto lbl_0
    wait(1)
    damage(eventPlayer, attacker, ceil(Ana_GrenadeDamage[0] / 100 * victim.getMaxHealth()))
    wait(1)
    damage(eventPlayer, attacker, ceil(Ana_GrenadeDamage[0] / 100 * victim.getMaxHealth()))
    wait(3)
    lbl_0:
