rule "[Emre]: Cyber Grenade Control + Burn":
    @Event playerDealtDamage
    @Hero emre
    @Condition eventAbility == Button.ABILITY_1
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT) or victim.has_nano) == false
    
    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 0.8)
    victim.setStatusEffect(attacker, Status.BURNING, 2)
    damage(victim, attacker, 75 + victim.getMaxHealth() * 0.25)


rule "[Emre]: Override Protocol Burn":
    @Event playerDealtDamage
    @Hero emre
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 0
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT) or victim.has_nano) == false
    
    victim.setStatusEffect(attacker, Status.BURNING, 2)
    damage(victim, attacker, 100 + victim.getMaxHealth() * 0.35)
