rule "[Genji] Dragonblade Execution players less 10% HP expectancy":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.zarya_buff[1] == null
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false
    @Condition victim.has_nano != true
    @Condition victim.getHealth() <= victim.getMaxHealth() * 0.1
    
    damage(victim, attacker, SojournBuff[1])
