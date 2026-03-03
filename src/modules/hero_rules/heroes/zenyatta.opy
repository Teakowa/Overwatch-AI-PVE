rule "[Zenyatta]: headshot damage":
    @Event playerDealtDamage
    @Hero zenyatta
    @Condition HeadshotDamage[0] > 2
    @Condition eventWasCriticalHit == true
    @Condition eventAbility != Button.ABILITY_1
    @Condition eventAbility != Button.ABILITY_2
    @Condition eventAbility != Button.ULTIMATE
    
    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[0] - 2)) / 2))
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
    
    eventPlayer.mov_speed_buff += 25
    wait(WAIT_SHORT_FRAME)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 6)
    eventPlayer.setHealingDealt(133.34)
    eventPlayer.setMoveSpeed(min(max(100 + eventPlayer.mov_speed_buff, 20), 200))
    waitUntil(not eventPlayer.isUsingUltimate() or eventPlayer.isDead(), 6)
    if eventPlayer.isDead() != true:
        eventPlayer.mov_speed_buff -= 25
        eventPlayer.setMoveSpeed(min(max(100 + eventPlayer.mov_speed_buff, 20), 200))
    eventPlayer.setHealingDealt(100)
