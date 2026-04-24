#!optimizeStrict

rule "[AI/control]: Ana Set botTarget":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getHero() in [Hero.GENJI, Hero.SOMBRA, Hero.SIGMA, Hero.FREJA, Hero.PHARAH, Hero.CASSIDY, Hero.ILLARI] == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition isInLoS(eventPlayer, eventPlayer.reset_pvar[7]) == true
    @Condition (eventPlayer.isUsingUltimate() or eventPlayer.isHoldingButton(Button.ULTIMATE)) == true
    @Condition eventPlayer.reset_pvar[7].botTarget == null
    
    eventPlayer.reset_pvar[7].botTarget = true
    wait(2)



rule "[AI/control]: Ana Sleep Drat Counter":
    @Event eachPlayer
    @Team 1
    @Hero ana
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    #@Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer, player) <= 22]) > 0
    @Condition eventPlayer.botTarget != null
    
    eventPlayer.botTarget = (sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.getHero() in [Hero.GENJI, Hero.SOMBRA, Hero.SIGMA, Hero.FREJA, Hero.PHARAH, Hero.CASSIDY, Hero.ILLARI] and isInLoS(eventPlayer, player)], lambda i: distance(eventPlayer, i)))[0]
    wait(random.uniform(0.08, 0.096 if eventPlayer.botTarget.getHero() == Hero.SOMBRA else 0.576), Wait.ABORT_WHEN_FALSE)
    #wait()
    eventPlayer.startFacing(updateEveryFrame(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition())), 10000)
    #botAim2Target()
    #eventPlayer.startFacing(updateEveryFrame(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getPosition() + eventPlayer.botTarget.getVelocity() * distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getPosition()) / ProjectileSpeed[eventPlayer.heroNum])), 10000)
    eventPlayer.setProjectileSpeed(125)
    if eventPlayer.botTarget.getHero() == Hero.GENJI:
        waitUntil(eventPlayer.botTarget.isUsingAbility1(), 0.096)
        eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()), Relativity.TO_WORLD)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    #eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()), Relativity.TO_WORLD)
    wait(WAIT_AI_THROTTLE_MIN)
    eventPlayer.stopFacing()
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.botTarget = null



