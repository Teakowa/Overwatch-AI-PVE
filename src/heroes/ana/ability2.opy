#!optimizeStrict

rule "[Ana] Biotic Grenade Hit":
    @Event playerTookDamage
    @Condition attacker.getHero() == Hero.ANA == true
    @Condition eventAbility == Button.ABILITY_2
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true

    if victim.zarya_buff[1] != null:
        goto lbl_0
    eventPlayer.setStatusEffect(attacker, Status.BURNING, ANA_ABILITY2_BURNING_DURATION)
    eventPlayer.burn_stack += 3
    eventPlayer.startDamageOverTime(victim, ANA_ABILITY2_DOT_DURATION, percentOf(Ana_GrenadeDamage[0], victim.getMaxHealth()))
    lbl_0:
