rule "[Kiriko]: headshot damage":
    @Event playerDealtDamage
    @Hero kiriko
    @Condition HeadshotDamage[2] > 1
    @Condition eventWasCriticalHit == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[2] - 2)) / 2))
