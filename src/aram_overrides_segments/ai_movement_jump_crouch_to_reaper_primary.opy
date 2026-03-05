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

rule "[AI/control]: Reaper Primary":
    @Event eachPlayer
    @Team 1
    @Hero reaper
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)

