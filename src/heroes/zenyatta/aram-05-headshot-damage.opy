rule "[Zenyatta]: headshot damage":
    @Event playerDealtDamage
    @Hero zenyatta
    @Condition HeadshotDamage[0] > 1
    @Condition eventWasCriticalHit == true
    @Condition eventAbility != Button.ABILITY_1
    @Condition eventAbility != Button.ABILITY_2
    @Condition eventAbility != Button.ULTIMATE
    
    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[0] - 2)) / 2))
