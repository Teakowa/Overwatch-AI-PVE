rule "[Tracer] Pulse Bomb Damage":
    @Event playerDealtDamage
    @Hero tracer
    #@Condition attacker.getHero() == Hero.TRACER == true
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 10
    
    damage(victim, attacker, ceil(eventDamage * 2))
