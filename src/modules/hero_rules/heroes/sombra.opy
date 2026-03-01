rule "[Sombra] TP to Support":
    @Event eachPlayer
    @Team 1
    @Hero sombra
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isFiringSecondaryFire() == false
    @Condition eventPlayer.isFiringPrimaryFire() == false
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) != 0
    @Condition (eventPlayer.reset_pvar[9][0].isAlive() and not eventPlayer.reset_pvar[9][0].isInSpawnRoom()) == true
    @Condition (not eventPlayer.isOnObjective() or not eventPlayer.isInSpawnRoom()) == true
    @Condition distance(eventPlayer, eventPlayer.reset_pvar[9][0]) >= 5.5
    @Condition distance(getClosestPlayer(eventPlayer, eventPlayer.getTeam()), eventPlayer.reset_pvar[9][0]) <= 30
    
    wait(2, Wait.ABORT_WHEN_FALSE)
    eventPlayer.teleport(nearestWalkablePosition(eventPlayer.reset_pvar[9][0] - worldVector(vect(0, 0, -7), eventPlayer, Transform.ROTATION)))
    eventPlayer.startFacing(vectorTowards(updateEveryFrame(eventPlayer.getEyePosition()), ((sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer.getEyePosition(), player.getEyePosition()) == true], lambda i: distance(eventPlayer.getEyePosition(), i.getEyePosition())))[0]).getEyePosition()), 10000)
    waitUntil(not eventPlayer.reset_pvar[4].reset_pvar[9][0].isAlive(), 2)
    eventPlayer.stopFacing()
    wait(3)


rule "[Sombra]: AI Auto use Translocator":
    @Event eachPlayer
    @Team 1
    @Hero sombra
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition (eventPlayer.isAlive() and eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0) == true
    @Condition distance(eventPlayer, eventPlayer.reset_pvar[9][0]) >= 5.5
    @Condition distance(getClosestPlayer(eventPlayer, eventPlayer.getTeam()), eventPlayer.reset_pvar[9][0]) <= 30
    
    eventPlayer.forceButtonPress(Button.ABILITY_2)


rule "[Zenyatta] Snap Kick (enemy)":
    @Event playerTookDamage
    @Condition eventAbility == Button.MELEE
    @Condition attacker.getHero() == Hero.ZENYATTA == true
    
    eventPlayer.KnockbackDirection = directionFromAngles(attacker.getHorizontalFacingAngle(), -10)
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0.5)
    Knockback()
    damage(eventPlayer, attacker, eventDamage * 0.5)
    eventPlayer.isKnocked = true


def Knockback():
    @Name "[Zenyatta] Sub Knockback"
    
    wait()
    eventPlayer.applyImpulse(eventPlayer.KnockbackDirection, Zen_KnockupStrength, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.applyImpulse(Vector.UP, Zen_KnockupStrength * 0.3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)


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


rule "[Zenyatta] stop knocked":
    @Event eachPlayer
    @Condition eventPlayer.isKnocked == true
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    eventPlayer.stopForcingThrottle()
    eventPlayer.isKnocked = false


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


