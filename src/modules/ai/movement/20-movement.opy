rule "[AI/Movement]: Movement":
    @Event eachPlayer
    @Team 1
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    
    if len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) == 0 or eventPlayer.botTarget == null:
        eventPlayer.startThrottleInDirection(directionTowards(eventPlayer, eventPlayer.reset_pvar[15]), 1, Relativity.TO_WORLD)
    else:
        eventPlayer.startThrottleInDirection(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, eventPlayer.botTarget)) + eventPlayer.Strafe, 0), 1, Relativity.TO_WORLD)
    eventPlayer.Strafe = 90 if distance(eventPlayer, eventPlayer.botTarget) <= FalloffMin[eventPlayer.heroNum] else 0 if eventPlayer.getHero() in getTankHeroes() else 45
    chaseAtRate(eventPlayer.Strafe, 90 if distance(eventPlayer, eventPlayer.botTarget) <= FalloffMin[eventPlayer.heroNum] else 0 if eventPlayer.getHero() in getTankHeroes() else 45, (0 if abs(eventPlayer.Strafe) == 90 else 9999) if distance(eventPlayer, eventPlayer.botTarget) <= FalloffMin[eventPlayer.heroNum] else 0 if abs(eventPlayer.Strafe) == 45 else 9999)
    eventPlayer.Strafe *= -1
    wait(0.5)
    if ruleCondition:
        loop()
    eventPlayer.stopThrottleInDirection()


rule "[AI/Movement]: Strafing":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getHero() != Hero.ILLARI
    @Condition eventPlayer.getHero() != Hero.ECHO
    @Condition eventPlayer.getHero() != Hero.GENJI
    @Condition len(getPlayersInRadius(eventPlayer, 22, getOppositeTeam(eventPlayer.getTeam()))) > 0
    
    eventPlayer.startThrottleInDirection(random.choice([Vector.LEFT, Vector.RIGHT]), 1, Relativity.TO_PLAYER)
    wait(random.uniform(0.2, 0.5), Wait.ABORT_WHEN_FALSE)
    wait(max(0.016, getAverageServerLoad() / 1000))
    if ruleCondition:
        loop()
    eventPlayer.stopThrottleInDirection()


rule "[AI/Movement]: Strafing Genji":
    @Event eachPlayer
    @Team 1
    @Hero genji
    @Condition eventPlayer.isAlive() == true
    @Condition len(getPlayersInRadius(eventPlayer, 22, getOppositeTeam(eventPlayer.getTeam()))) > 0
    
    eventPlayer.startThrottleInDirection(random.choice([Vector.LEFT, Vector.RIGHT]), 1, Relativity.TO_PLAYER)
    wait(random.uniform(0.2, 0.8), Wait.ABORT_WHEN_FALSE)
    wait(max(0.016, getAverageServerLoad() / 1000))
    if ruleCondition:
        loop()
    eventPlayer.stopThrottleInDirection()


rule "[AI/Movement]: Jump Crouch":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isAlive() == true
    #@Condition eventPlayer.isUsingUltimate() == false
    @Condition (len(getPlayersInRadius(eventPlayer, 22, getOppositeTeam(eventPlayer.getTeam()))) > 0 or eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire()) == true
    
    if random.randint(1, 100) <= 33:
        goto lbl_0
    eventPlayer.startForcingButton(Button.CROUCH)
    if eventPlayer.getHero() != Hero.BAPTISTE:
        goto lbl_1
    wait(random.uniform(0.25, 0.3))
    eventPlayer.forceButtonPress(Button.JUMP)
    lbl_1:
    wait(random.uniform(0, 0.2))
    eventPlayer.stopForcingButton(Button.CROUCH)
    lbl_0:
    if random.randint(1, 100) <= 33:
        goto lbl_2
    if eventPlayer.getHero() == Hero.WIDOWMAKER and eventPlayer.isFiringSecondaryFire():
        goto lbl_3
    eventPlayer.forceButtonPress(Button.JUMP)
    if eventPlayer.getHero() == Hero.HANZO:
        wait(0.5)
        eventPlayer.forceButtonPress(Button.JUMP)
    lbl_2:
    lbl_3:
    wait(0.6)
    if ruleCondition:
        loop()


rule "[AI/Movement]: reset speed":
    @Event eachPlayer
    @Team 1
    @Hero torbjorn
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setProjectileSpeed(50)
    waitUntil(not eventPlayer.isUsingUltimate(), 15)
    eventPlayer.setProjectileSpeed(100)

