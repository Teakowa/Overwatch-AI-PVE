rule "[AI/control]: Venture Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero venture
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    
    waitUntil(true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 20, 99999)
    eventPlayer.startForcingButton(Button.ULTIMATE)


rule "[AI/control]: Vendetta Primary":
    @Event eachPlayer
    @Team 1
    @Hero vendetta
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    wait(max(getServerLoad() / 1000, 0.192))
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "[AI/control]: Vendetta Secondary":
    @Event playerTookDamage
    @Team 1
    @Hero vendetta
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(max(getServerLoad() / 1000, 0.192))
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)


rule "[AI/control]: Vendetta Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero vendetta
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    waitUntil(true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 6.8, random.uniform(0.65, 1.2))
    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(max(getServerLoad() / 1000, 0.192))
    eventPlayer.stopForcingButton(Button.ABILITY_1)


rule "[AI/control]: Vendetta Ability 2":
    @Event eachPlayer
    @Team 1
    @Hero vendetta
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) != true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(1)
    eventPlayer.stopForcingButton(Button.ABILITY_2)


rule "[AI/control]: Vendetta Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero vendetta
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    
    waitUntil(true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 16 or eventPlayer.isInAir(), 99999)
    resetStatuses()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    wait(random.uniform(2, 4))
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)


rule "[AI/control]: Tracer Primary":
    @Event eachPlayer
    @Team 1
    @Hero tracer
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition entityExists(eventPlayer.botTarget[0]) == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) != true
    @Condition isInLoS(eventPlayer.getEyePosition(), eventPlayer.botTarget[0].getEyePosition()) == true
    @Condition eventPlayer.botTarget != null
    #@Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(max(getServerLoad() / 1000, 0.5))
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "[AI/control]: Tracer Recall (Remove Pluse Bomb)":
    @Event playerTookDamage
    @Team 1
    @Hero tracer
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker.getHero() == Hero.TRACER == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(max(getServerLoad() / 1000, 0.1))


rule "[AI/control]: Widowmaker Fly Sky Attack Mode":
    @Event eachPlayer
    @Team 1
    @Hero widowmaker
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isFiringPrimaryFire() == false
    @Condition eventPlayer.isOnGround() == true
    @Condition eventPlayer.getPosition().y > -2
    @Condition (eventPlayer.hasStatus(Status.KNOCKED_DOWN) or eventPlayer.hasStatus(Status.ASLEEP) or eventPlayer.hasStatus(Status.FROZEN)) != true
    @Condition len(getPlayersInRadius(eventPlayer, 22, getOppositeTeam(eventPlayer.getTeam()))) > 0
    
    wait(0.3)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 4)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.setDamageReceived(70)
    if not eventPlayer.isOnGround():
        goto lbl_0
    eventPlayer.applyImpulse(vect(random.uniform(-0.3, 0.3), 1, random.uniform(-0.3, 0.3)), 30, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.setGravity(0)
    wait(1.2)
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    eventPlayer.setGravity(60)
    wait(0.4)
    lbl_0:
    eventPlayer.setGravity(80)
    waitUntil(eventPlayer.isOnGround(), 999999986991104)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setGravity(100)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    wait(3)
    if ruleCondition:
        loop()


rule "[AI/control]: Genji Ability 2":
    @Event playerTookDamage
    @Team 1
    @Hero genji
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    #@Condition eventPlayer.isUsingAbility2() == true
    #@Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    wait()
    if len(eventPlayer.botTemp) <= 0:
        goto lbl_0
    botAim2Target()
    lbl_0:
    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(2)
    eventPlayer.stopFacing()
    eventPlayer.stopForcingButton(Button.ABILITY_2)


rule "[AI/control]: Genji Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero genji
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(0.5)
    if ruleCondition:
        loop()


rule "[AI/control]: Hazard Primary":
    @Event eachPlayer
    @Team 1
    @Hero hazard
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    wait(max(getServerLoad() / 1000, 0.192))
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "[AI/control]: Hazard Secondary":
    @Event playerTookDamage
    @Team 1
    @Hero hazard
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(0.192)
    wait(0.192, Wait.RESTART_WHEN_TRUE)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)


rule "[AI/control]: Hazard Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero hazard
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) != true
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.ABILITY_1)
    waitUntil(eventPlayer.getAltitude() > 0.1, 99999)
    waitUntil(eventPlayer.getAltitude() < 0.1, 99999)
    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(0.192)
    eventPlayer.stopForcingButton(Button.ABILITY_1)


rule "[AI/control]: Hazard Ability 2":
    @Event eachPlayer
    @Team 1
    @Hero hazard
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) != true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(2)


