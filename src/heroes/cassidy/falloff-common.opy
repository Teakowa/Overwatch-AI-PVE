    eventPlayer.scoped_shot_distance = distance(attacker.getEyePosition(), victim)
    #原OW2衰减计算（25-35米 70%衰减）
    eventPlayer.ow2_scoped_damage_falloff_scalar = 1 - (((eventPlayer.scoped_shot_distance - 25) / 10) * 0.7) + (1 - ((eventPlayer.scoped_shot_distance - 25) / 10))
    if eventPlayer.ow2_scoped_damage_falloff_scalar > 1:
        eventPlayer.ow2_scoped_damage_falloff_scalar = 1
        #Min damage scalar
    elif eventPlayer.ow2_scoped_damage_falloff_scalar < 0.3:
        eventPlayer.ow2_scoped_damage_falloff_scalar = 0.3
    eventPlayer.scoped_damage_base = eventDamage / eventPlayer.ow2_scoped_damage_falloff_scalar
    eventPlayer.ow1_scoped_damage_falloff_scalar = 1 - (((eventPlayer.scoped_shot_distance - 25) / 25) * 0.3)
    if eventPlayer.ow1_scoped_damage_falloff_scalar < 0.7:
        eventPlayer.ow1_scoped_damage_falloff_scalar = 0.7
    if eventPlayer.scoped_shot_distance > 50:
        eventPlayer.ow1_scoped_damage_falloff_scalar = 0.7
    eventPlayer.expected_scoped_damage = eventPlayer.scoped_damage_base * eventPlayer.ow1_scoped_damage_falloff_scalar
    damage(victim, attacker, ceil(eventPlayer.expected_scoped_damage - eventDamage))
