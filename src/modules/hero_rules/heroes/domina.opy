rule "[Domina]: Sonic Repulsion Field Debuff":
    @Event playerDealtKnockback
    @Hero domina
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim.isAlive() == true
    @Condition victim.unaffected != true
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    victim.mov_speed_penalty += 70
    victim.setMoveSpeed(100 - victim.mov_speed_penalty + victim.mov_speed_buff)
    victim.setStatusEffect(attacker, Status.STUNNED, 0.8)
    wait(2)
    victim.mov_speed_penalty = max(0, victim.mov_speed_penalty - 70)
    victim.setMoveSpeed(100 - victim.mov_speed_penalty + victim.mov_speed_buff)


rule "[Domina]: Energy Crystal Slow":
    @Event playerDealtDamage
    @Hero domina
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.isAlive() == true
    @Condition victim.unaffected != true
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    victim.mov_speed_penalty += 70
    victim.setMoveSpeed(100 - victim.mov_speed_penalty + victim.mov_speed_buff)
    wait(2)
    victim.mov_speed_penalty = max(0, victim.mov_speed_penalty - 70)
    victim.setMoveSpeed(100 - victim.mov_speed_penalty + victim.mov_speed_buff)
