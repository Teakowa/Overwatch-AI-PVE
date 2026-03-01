rule "[Tracer]: Recall follow Sombra":
    @Event eachPlayer
    @Team 1
    @Hero tracer
    @Condition eventPlayer.reset_pvar[4] != null
    @Condition eventPlayer.reset_pvar[4].reset_pvar[9] != null
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isFiringSecondaryFire() == false
    @Condition eventPlayer.isFiringPrimaryFire() == false
    @Condition eventPlayer.reset_pvar[4].isAlive() == true
    @Condition eventPlayer.reset_pvar[4].reset_pvar[9][0].isAlive() == true
    @Condition (not eventPlayer.isOnObjective() or not eventPlayer.isInSpawnRoom()) == true
    @Condition distance(eventPlayer.reset_pvar[4], eventPlayer.reset_pvar[4].reset_pvar[9][0]) <= 5.5
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    
    wait(0.8, Wait.ABORT_WHEN_FALSE)
    eventPlayer.startForcingButton(Button.ABILITY_2)
    waitUntil(not eventPlayer.isUsingAbility2(), 0.91)
    eventPlayer.teleport(nearestWalkablePosition(eventPlayer.reset_pvar[4][0] - worldVector(vect(0, 0, -5), eventPlayer, Transform.ROTATION)))
    eventPlayer.startFacing(vectorTowards(updateEveryFrame(eventPlayer.getEyePosition()), ((sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer.getEyePosition(), player.getEyePosition()) == true], lambda i: distance(eventPlayer.getEyePosition(), i.getEyePosition())))[0]).getEyePosition()), 10000)
    waitUntil(not eventPlayer.reset_pvar[4].reset_pvar[9][0].isAlive(), 3)
    eventPlayer.stopFacing()


rule "[Ana]: Sleep tanks for longer duration":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.unaffected == false
    
    victim.clearStatusEffect(Status.ASLEEP)
    #waitUntil(victim.hasStatus(Status.ASLEEP), WAIT_TIMEOUT_FOREVER)
    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 4)


rule "[Wrecking Ball] Disable Adaptive Shield for allies":
    @Event eachPlayer
    @Hero wreckingBall
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingAbility2() == true
    @Disabled
    
    eventPlayer.disallowButton(Button.ABILITY_2)
    waitUntil(not eventPlayer.isUsingAbility2() or eventPlayer.reset_pvar[0] != false, 7)
    eventPlayer.allowButton(Button.ABILITY_2)


rule "[Zarya]: Projected Barrier Target":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isUsingAbility2() == true
    
    [i for i in sorted(getLivingPlayers(eventPlayer.getTeam()), lambda player: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getPosition(), player.getPosition()))) if i.hasStatus(Status.INVINCIBLE)][0].zarya_barrier_shields[0] = true


rule "[Zarya]: Projected Barrier Shields":
    @Event eachPlayer
    @Condition eventPlayer.getHero() != Hero.ZARYA
    @Condition (eventPlayer.isAlive() and eventPlayer.zarya_barrier_shields[0]) == true
    
    if eventPlayer.mauga_berserker_soul == true:
        goto lbl_0
    resetStatuses()
    lbl_0:
    eventPlayer.zarya_barrier_shields[0] = false
    if eventPlayer.zarya_barrier_shields[1] == null:
        goto lbl_1
    removeHealthPool(eventPlayer.zarya_barrier_shields[1])
    lbl_1:
    eventPlayer.addHealthPool(Health.NORMAL, 50, false, false)
    eventPlayer.zarya_barrier_shields[1] = getLastCreatedHealthPool()
    wait(3, Wait.RESTART_WHEN_TRUE)
    removeHealthPool(eventPlayer.zarya_barrier_shields[1])
    eventPlayer.zarya_barrier_shields[1] = null


rule "[Genji]: Deflect":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 2.192)
    eventPlayer.setDamageDealt(200)
    waitUntil(not eventPlayer.isUsingAbility2(), 3)
    eventPlayer.setDamageDealt(100)


