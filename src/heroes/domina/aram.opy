rule "[Domina]: Sonic Repulsion Field Debuff":

    @Event playerDealtKnockback

    @Hero domina

    @Condition eventAbility == Button.SECONDARY_FIRE

    @Condition victim.isAlive() == true

    @Condition victim.unaffected != true

    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    if abs(victim.mov_speed_buff) < DOMINA_SLOW_PERCENT:

        victim.mov_speed_buff = -DOMINA_SLOW_PERCENT

        victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))

    victim.setStatusEffect(attacker, Status.STUNNED, DOMINA_SONIC_STUN_DURATION)

    wait(DOMINA_SLOW_DURATION)

    if victim.isDead():

        goto lbl_0

    if victim.mov_speed_buff == -DOMINA_SLOW_PERCENT:

        victim.mov_speed_buff = 0

        victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))

    lbl_0:

rule "[Domina]: Energy Crystal Slow":

    @Event playerDealtDamage

    @Hero domina

    @Condition eventAbility == Button.ABILITY_1

    @Condition victim.isAlive() == true

    @Condition victim.unaffected != true

    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    if abs(victim.mov_speed_buff) < DOMINA_SLOW_PERCENT:

        victim.mov_speed_buff = -DOMINA_SLOW_PERCENT

        victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))

    wait(DOMINA_SLOW_DURATION)

    if victim.isDead():

        goto lbl_0

    if victim.mov_speed_buff == -DOMINA_SLOW_PERCENT:

        victim.mov_speed_buff = 0

        victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))

    lbl_0:
