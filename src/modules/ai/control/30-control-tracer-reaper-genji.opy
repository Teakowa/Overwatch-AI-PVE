rule "[AI]: Target in line of sight":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.getHero() in CustomAIArray.concat([Hero.REAPER, Hero.KIRIKO, Hero.MAUGA, Hero.SOJOURN, Hero.GENJI, Hero.TRACER]) == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer, player) <= 22]) > 0
    #@Condition getPlayersInRadius(eventPlayer.getEyePosition(), 50, getOppositeTeam(eventPlayer.getTeam()))[0] != false
    
    eventPlayer.botTemp = [player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player)]
    wait()
    if not eventPlayer.botTemp:
        eventPlayer.botTarget = null
        goto lbl_0
    eventPlayer.botTemp.remove([player for player in eventPlayer.botTemp if not player.hasSpawned() or player.hasStatus(Status.INVINCIBLE) or player.hasStatus(Status.PHASED_OUT) or player.getHero() == Hero.ORISA and player.isUsingAbility1() or player.getHero() == Hero.GENJI and player.isUsingAbility2() or player.getHero() == Hero.DOOMFIST and player.isUsingAbility2()])
    wait()
    if len(eventPlayer.botTemp) > 1:
        eventPlayer.botTemp = sorted(eventPlayer.botTemp, lambda player: player.getHealth() * distance(eventPlayer, player))
        wait()
    eventPlayer.botTarget = eventPlayer.botTemp[0]
    lbl_0:
    wait(random.uniform(0.256, 0.512))
    if ruleCondition:
        loop()
    #eventPlayer.botTarget = null


rule "[AI]: Target increase aim to prep for flicking to a target entering range":
    @Event eachPlayer
    @Team 1
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.botTarget != null
    
    botAim2Target()


rule "[AI/control]: Tracer Ability 2":
    @Event playerTookDamage
    @Team 1
    @Hero tracer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isInSpawnRoom() != true
    
    waitUntil(eventPlayer.getNormalizedHealth() < 0.3, 3)
    eventPlayer.forceButtonPress(Button.ABILITY_2)


rule "[AI/control]: Tracer Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero tracer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    
    waitUntil(true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 2.6, 99999)
    eventPlayer.startForcingButton(Button.ULTIMATE)
    wait(3)
    eventPlayer.stopForcingButton(Button.ULTIMATE)


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


rule "[AI/control]: Sojourn Ability 1":
    @Event playerTookDamage
    @Team 1
    @Hero sojourn
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.isAlive() == true
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer, player) <= 22]) > 0
    
    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(0.75)
    eventPlayer.stopForcingButton(Button.ABILITY_1)
    eventPlayer.forceButtonPress(Button.JUMP)
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    wait(0.25)


rule "[AI/control]: Kiriko Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero kiriko
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) != true
    @Condition eventPlayer.getNormalizedHealth() < 0.5
    
    if len(getLivingPlayers(Team.2)) < 2:
        goto lbl_0
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), (sorted(getLivingPlayers(Team.1).exclude(eventPlayer), lambda i: i.getHealth())[0].getEyePosition() + sorted(getLivingPlayers(Team.1).exclude(eventPlayer), lambda i: i.getHealth()).getPosition()) / 2), 10000)
    wait(WAIT_AI_THROTTLE_MIN)
    eventPlayer.startForcingButton(Button.ABILITY_1)
    waitUntil(eventPlayer.isUsingAbility1(), 5)
    eventPlayer.startFacing(updateEveryFrame(directionTowards(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition() + eventPlayer.botTarget.getVelocity() * distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) / ProjectileSpeed[getAllHeroes().index(eventPlayer.getHero())])), 10000)
    lbl_0:
    eventPlayer.setProjectileSpeed(0)
    eventPlayer.setProjectileGravity(500)
    wait(WAIT_AI_THROTTLE_MIN)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.startForcingButton(Button.ABILITY_2)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2), 5)
    eventPlayer.stopForcingButton(Button.ABILITY_2)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)


