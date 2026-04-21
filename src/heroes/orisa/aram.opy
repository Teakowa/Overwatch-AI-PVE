rule "[Orisa]: Fortify provides 100 temporary armor":

    @Event eachPlayer

    @Hero orisa

    @Condition Orisa_Fortify[0] != 0

    @Condition any([i == true for i in [eventPlayer.isUsingAbility1(), eventPlayer.isUsingUltimate()]]) == true

    wait(0.16)

    eventPlayer.unaffected = true

    eventPlayer.hazard_buff[0] = false

    eventPlayer.zarya_graviton_buff[0] = false

    eventPlayer.brigitte_buff[0] = false

    eventPlayer.orisa_buff = false

    eventPlayer.addHealthPool(Health.ARMOR, Orisa_Fortify[0], true, false)

    eventPlayer.orisa_fortify_armor_id = getLastCreatedHealthPool()

    eventPlayer.startHealingOverTime(eventPlayer, eventPlayer.getMaxHealth() * 0.1, 4)

    if eventPlayer.isUsingAbility1() == true:

        waitUntil(not eventPlayer.isUsingAbility1(), 999999986991104)

    else:

        waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)

    removeHealthPool(eventPlayer.orisa_fortify_armor_id)

    eventPlayer.unaffected = false

rule "[Orisa]Fortify ricochet damage":

    @Event playerTookDamage

    @Hero orisa

    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true

    @Condition eventPlayer.hasStatus(Status.HACKED) != true

    damage(attacker, eventPlayer, Orisa_Fortify[1] / 100 * eventDamage)

rule "[Orisa]: stun when ult":

    @Event playerDealtKnockback

    @Hero orisa

    @Condition eventAbility == Button.SECONDARY_FIRE

    @Condition victim.isAlive() == true

    @Condition victim.unaffected != true

    wait(0.3, Wait.ABORT_WHEN_FALSE)

    if victim.zarya_buff[1] != null:

        goto lbl_0

    victim.orisa_buff = true

    lbl_0:

    victim.mov_speed_penalty += Orisa_Fortify[2]

rule "[Orisa]: speed":

    @Event eachPlayer

    @Condition eventPlayer.isAlive() == true

    @Condition eventPlayer.unaffected != true

    @Condition eventPlayer.orisa_buff == true

    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff - eventPlayer.mov_speed_penalty)

    waitUntil(not eventPlayer.orisa_buff or eventPlayer.unaffected or eventPlayer.hasStatus(Status.INVINCIBLE) or eventPlayer.hasStatus(Status.PHASED_OUT), 2)

    eventPlayer.mov_speed_penalty = 0

    eventPlayer.setMoveSpeed(100)

    eventPlayer.orisa_buff = false

rule "[Orisa]: fly":

    @Event eachPlayer

    @Hero orisa

    @Condition (eventPlayer.isUsingAbility2() or eventPlayer.isUsingUltimate()) == true

    #@Condition eventPlayer.isUsingAbility2() == true

    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)

    wait()

    if ruleCondition:

        loop()
