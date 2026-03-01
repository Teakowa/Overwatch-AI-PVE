rule "[AI/control]: Ramattra Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero ramattra
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition (not eventPlayer.getAbilityCooldown(Button.ABILITY_1)) == true
    @Condition (not eventPlayer.isUsingAbility1()) == true
    @Condition distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition()) <= 10
    @Condition (not eventPlayer.isUsingUltimate()) == true
    
    eventPlayer.startForcingButton(Button.ABILITY_1)
    #wait(WAIT_AI_THROTTLE_MIN)
    #eventPlayer.stopForcingButton(Button.ABILITY_1)


rule "[AI/control]: Ramattra Ability 2":
    @Event playerTookDamage
    @Team 1
    @Hero ramattra
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition any([i == true for i in [eventPlayer.isUsingAbility1(), eventPlayer.isUsingUltimate()]]) == true
    
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    #wait(WAIT_AI_THROTTLE_MIN)
    #eventPlayer.stopForcingButton(Button.ABILITY_1)
    if eventPlayer.isUsingAbility1() == true:
        waitUntil(not eventPlayer.isUsingAbility1(), WAIT_TIMEOUT_FOREVER)
    else:
        waitUntil(not eventPlayer.isUsingUltimate(), WAIT_TIMEOUT_FOREVER)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)


rule "[AI/control]: Mauga Secondary":
    @Event eachPlayer
    @Team 1
    @Hero mauga
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer, player) <= 10]) > 0
    @Disabled
    
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    waitUntil(distance(eventPlayer.getPosition(), eventPlayer.botTarget) > 10 or len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer, player) <= 10]) == 0, 99999)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)


rule "[AI/control]: Mauga Ability 2":
    @Event playerTookDamage
    @Team 1
    @Hero mauga
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) < 0.5
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getNormalizedHealth() < 0.5
    
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(3)


rule "[AI/control]: Freja Primary":
    @Event eachPlayer
    @Team 1
    @Hero freja
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    #@Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    waitUntil(eventPlayer.isUsingAbility1(), 1.5)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(max(getServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(max(getServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    wait(max(getServerLoad() / 1000, 0.5))
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.forceButtonPress(Button.RELOAD)


rule "[AI/control]: Freja Ability 2":
    @Event eachPlayer
    @Team 1
    @Hero freja
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) != true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(1)
    eventPlayer.stopForcingButton(Button.ABILITY_2)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(max(getServerLoad() / 1000, 0.4))
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(max(getServerLoad() / 1000, 0.4))


rule "[AI/control]: Freja Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero freja
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    waitUntil(true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 18.6, 99999)
    eventPlayer.startForcingButton(Button.ULTIMATE)
    wait(3)
    eventPlayer.stopForcingButton(Button.ULTIMATE)


rule "[AI/control]: Freja Ammo":
    @Event eachPlayer
    @Team 1
    @Hero freja
    @Condition eventPlayer.getAmmo() <= 1
    #@Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2() or eventPlayer.isUsingUltimate()) == true
    
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())


rule "[AI/control]: Pharah Primary":
    @Event eachPlayer
    @Team 1
    @Hero pharah
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(max(getServerLoad() / 1000, 1))
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "[AI/control]: Pharah Secondary":
    @Event playerTookDamage
    @Team 1
    @Hero pharah
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(max(getServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    wait(4)


rule "[AI/control]: Pharah Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero pharah
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(max(getServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.ABILITY_1)


rule "[AI/control]: Pharah Ability 2":
    @Event eachPlayer
    @Team 1
    @Hero pharah
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(max(getServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.ABILITY_2)


rule "[AI/control]: Pharah Jump":
    @Event eachPlayer
    @Team 1
    @Hero pharah
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.JUMP)
    wait(max(getServerLoad() / 1000, 0.333))
    eventPlayer.stopForcingButton(Button.JUMP)
    wait(0.167)
    while eventPlayer.isInAir():
        eventPlayer.startForcingButton(Button.JUMP)
        wait(max(getServerLoad() / 1000, 0.333))
        eventPlayer.stopForcingButton(Button.JUMP)
        wait(max(getServerLoad() / 1000, 0.333))
    wait(1.167)
    loop()


rule "[AI/control]: Pharah Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero pharah
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    
    waitUntil(true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 10, 99999)
    eventPlayer.startForcingButton(Button.ULTIMATE)


rule "[AI/control]: Venture Primary":
    @Event eachPlayer
    @Team 1
    @Hero venture
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    wait(max(getServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "[AI/control]: Venture Secondary":
    @Event eachPlayer
    @Team 1
    @Hero venture
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)


rule "[AI/control]: Venture Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero venture
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.ABILITY_1)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.startThrottleInDirection(directionTowards(eventPlayer.getPosition(), eventPlayer.botTarget), 1, Relativity.TO_WORLD)
    wait(WAIT_AI_THROTTLE_MIN)
    eventPlayer.stopForcingButton(Button.ABILITY_1)
    wait(3.792)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(random.uniform(0.65, 1.3))
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    wait(0.624)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.startThrottleInDirection(directionFromAngles(horizontalAngleOfDirection(directionTowards(eventPlayer, eventPlayer.botTarget)) + eventPlayer.Strafe, 0), 1, Relativity.TO_WORLD)
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


