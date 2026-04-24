#!optimizeStrict

rule "[Zenyatta]: headshot damage":
    @Event playerDealtDamage
    @Hero zenyatta
    @Condition HeadshotDamage[0] > 1
    @Condition eventWasCriticalHit == true
    @Condition eventAbility != Button.ABILITY_1
    @Condition eventAbility != Button.ABILITY_2
    @Condition eventAbility != Button.ULTIMATE

    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[0] - 2)) / 2))

rule "[Zenyatta] remove Snap Kick hp":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.heart_steel[1] != 0

    wait(5)
    removeHealthPool(eventPlayer.heart_steel[0])
    eventPlayer.heart_steel[1] = 0
    eventPlayer.heart_steel[0] = 0
    wait(0.16)
    if ruleCondition:
        loop()

rule "[Zenyatta] Snap Kick (enemy)":
    @Event playerReceivedKnockback
    @Condition attacker.getHero() == Hero.ZENYATTA == true
    @Condition eventAbility == Button.MELEE

    heal(attacker, attacker, victim.getMaxHealth() * 0.25)
    victim.setStatusEffect(attacker, Status.STUNNED, 1.5)
    attacker.heart_steel[1] += 150
    if attacker.heart_steel[0] == null:
        goto lbl_0
    removeHealthPool(attacker.heart_steel[0])
    lbl_0:
    attacker.addHealthPool(Health.NORMAL, attacker.heart_steel[1], false, false)
    attacker.heart_steel[0] = getLastCreatedHealthPool()
    wait()
    damage(eventPlayer, attacker, eventDamage * 0.5)

rule "[Zenyatta] stop knocked":
    @Event eachPlayer
    @Condition eventPlayer.isKnocked == true

    wait(0.016, Wait.ABORT_WHEN_FALSE)
    eventPlayer.stopForcingThrottle()
    eventPlayer.isKnocked = false

rule "[Zenyatta] Snap Kick (Self Ground)":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isMeleeing() == Button.MELEE
    @Condition eventPlayer.getVerticalFacingAngle() >= 45

    if distance(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2.51, getAllPlayers(), eventPlayer, true).getHitPosition(), eventPlayer.getEyePosition()) <= 2.5:
        eventPlayer.KnockbackDirection = eventPlayer.getFacingDirection() * -1
        Knockback()

rule "[Zenyatta] Snap Kick (Self Wall)":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isMeleeing() == Button.MELEE
    @Condition eventPlayer.getVerticalFacingAngle() < 45

    if distance(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2.51, getAllPlayers(), eventPlayer, true).getHitPosition(), eventPlayer.getEyePosition()) <= 2.5:
        if raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 5, getAllPlayers(), eventPlayer, true).getPlayerHit() == null:
            eventPlayer.KnockbackDirection = eventPlayer.getFacingDirection() * -1
            Knockback()

rule "[Zenyatta]: Transcendence":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.mov_speed_penalty = 0
    eventPlayer.mov_speed_buff += 25
    wait(0.16)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 6)
    eventPlayer.setHealingDealt(133.34)
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff)
    waitUntil(not eventPlayer.isUsingUltimate(), 6)
    eventPlayer.mov_speed_buff = 0
    eventPlayer.setHealingDealt(100)
    eventPlayer.setMoveSpeed(100)
