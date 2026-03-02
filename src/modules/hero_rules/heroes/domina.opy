rule "[Domina]: Sonic Repulsion Field Debuff":
    @Event playerDealtKnockback
    @Hero domina
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim.isAlive() == true
    @Condition victim.unaffected != true
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    victim.mov_speed_buff -= 70
    victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
    victim.setStatusEffect(attacker, Status.STUNNED, 0.8)
    wait(2)
    if victim.isDead():
        goto lbl_0
    victim.mov_speed_buff += 70
    victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
    lbl_0:


rule "[Domina]: Energy Crystal Slow":
    @Event playerDealtDamage
    @Hero domina
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.isAlive() == true
    @Condition victim.unaffected != true
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    victim.mov_speed_buff -= 70
    victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
    wait(2)
    if victim.isDead():
        goto lbl_0
    victim.mov_speed_buff += 70
    victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
    lbl_0:
