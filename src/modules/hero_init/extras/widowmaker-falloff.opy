rule "[widowmaker.opy]: Infra-Sight headshot x3":
    @Event playerDealtDamage
    @Hero widowmaker
    @Condition eventWasCriticalHit == true
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isFiringPrimaryFire() == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    damage(victim, attacker, (3 / 2.5 - 1) * eventDamage)


rule "[widowmaker.opy]: Revert sniper damage falloff":
    @Event playerDealtDamage
    @Hero widowmaker
    @Condition eventPlayer.getHero() == Hero.WIDOWMAKER == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isFiringPrimaryFire() == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    eventPlayer.scoped_shot_distance = distance(attacker.getEyePosition(), victim)
    eventPlayer.ow2_scoped_damage_falloff_scalar = ((eventPlayer.scoped_shot_distance - 50) / 20) * 0.5 + (1 - ((eventPlayer.scoped_shot_distance - 50) / 20))
    #Cap min/max scalar
    # Max damage scalar
    if eventPlayer.ow2_scoped_damage_falloff_scalar > 1:
        eventPlayer.ow2_scoped_damage_falloff_scalar = 1
        #Min damage scalar
    elif eventPlayer.ow2_scoped_damage_falloff_scalar < 0.5:
        eventPlayer.ow2_scoped_damage_falloff_scalar = 0.5
    eventPlayer.scoped_damage_base = eventDamage / eventPlayer.ow2_scoped_damage_falloff_scalar
    eventPlayer.ow1_scoped_damage_falloff_scalar = ((eventPlayer.scoped_shot_distance - 70) / 30) * 0.3 + (1 - ((eventPlayer.scoped_shot_distance - 70) / 30))
    #Cap min/max scalar
    # Max damage scalar
    if eventPlayer.ow1_scoped_damage_falloff_scalar > 1:
        eventPlayer.ow1_scoped_damage_falloff_scalar = 1
        #Min damage scalar
    elif eventPlayer.ow1_scoped_damage_falloff_scalar < 0.3:
        eventPlayer.ow1_scoped_damage_falloff_scalar = 0.3
    eventPlayer.expected_scoped_damage = eventPlayer.scoped_damage_base * eventPlayer.ow1_scoped_damage_falloff_scalar
    damage(victim, attacker, ceil(eventPlayer.expected_scoped_damage - eventDamage))


