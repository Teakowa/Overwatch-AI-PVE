#!mainFile "../../../main.opy"
#!optimizeStrict

rule "[AI/Movement]: Movement":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition not isMatchBetweenRounds()
    
    eventPlayer.botHasNearbyEnemy = len(getPlayersInRadius(eventPlayer, 22, getOppositeTeam(eventPlayer.getTeam()))) > 0
    if eventPlayer.botTarget == null or eventPlayer.botTarget.isAlive() != true or isInLoS(eventPlayer, eventPlayer.botTarget) != true:
        eventPlayer.botTargetDistance = null
        eventPlayer.startThrottleInDirection(directionTowards(eventPlayer, eventPlayer.reset_pvar[15]), 1, Relativity.TO_WORLD)
        eventPlayer.Strafe = 0
        chaseAtRate(eventPlayer.Strafe, 0, 9999)
    else:
        eventPlayer.botTargetDistance = distance(eventPlayer, eventPlayer.botTarget)
        eventPlayer.startThrottleInDirection(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, eventPlayer.botTarget)) + eventPlayer.Strafe, 0), 1, Relativity.TO_WORLD)
        if eventPlayer.botTargetDistance <= FalloffMin[eventPlayer.heroNum]:
            eventPlayer.Strafe = 90
            chaseAtRate(eventPlayer.Strafe, 90, 0)
        elif eventPlayer.getHero() in getTankHeroes():
            eventPlayer.Strafe = 0
            chaseAtRate(eventPlayer.Strafe, 0, 9999)
        else:
            eventPlayer.Strafe = 45
            chaseAtRate(eventPlayer.Strafe, 45, 0)
    eventPlayer.Strafe *= -1
    wait(0.5)
    if ruleCondition:
        loop()
    eventPlayer.stopThrottleInDirection()


rule "[AI/Movement]: Strafing":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isAlive() == true
    @Condition not isHero(eventPlayer, Hero.ILLARI)
    @Condition not isHero(eventPlayer, Hero.ECHO)
    @Condition not isHero(eventPlayer, Hero.GENJI)
    @Condition not isMatchBetweenRounds()
    @Condition eventPlayer.botHasNearbyEnemy == true
    
    eventPlayer.startThrottleInDirection(random.choice([Vector.LEFT, Vector.RIGHT]), 1, Relativity.TO_PLAYER)
    wait(random.uniform(0.2, 0.5), Wait.ABORT_WHEN_FALSE)
    wait(WAIT_SHORT_FRAME)
    if ruleCondition:
        loop()
    eventPlayer.stopThrottleInDirection()


rule "[AI/Movement]: Strafing Genji":
    @Event eachPlayer
    @Team 1
    @Hero genji
    @Condition eventPlayer.isAlive() == true
    @Condition not isMatchBetweenRounds()
    @Condition eventPlayer.botHasNearbyEnemy == true
    
    eventPlayer.startThrottleInDirection(random.choice([Vector.LEFT, Vector.RIGHT]), 1, Relativity.TO_PLAYER)
    wait(random.uniform(0.2, 0.8), Wait.ABORT_WHEN_FALSE)
    wait(WAIT_SHORT_FRAME)
    if ruleCondition:
        loop()
    eventPlayer.stopThrottleInDirection()


rule "[AI/Movement]: Jump Crouch":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isAlive() == true
    @Condition not isMatchBetweenRounds()
    #@Condition eventPlayer.isUsingUltimate() == false
    @Condition (eventPlayer.botHasNearbyEnemy == true or eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire()) == true
    
    if random.randint(1, 100) <= 33:
        goto lbl_0
    eventPlayer.startForcingButton(Button.CROUCH)
    if not isHero(eventPlayer, Hero.BAPTISTE):
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
    if isHero(eventPlayer, Hero.HANZO):
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
