rule "[Sigma]: ult damage":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 75
    
    damage(victim, attacker, eventDamage / 2)
