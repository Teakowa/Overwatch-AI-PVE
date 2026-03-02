rule "[AI/control]: Hazard Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero hazard
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    
    waitUntil(true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 25.5, 99999)
    eventPlayer.startForcingButton(Button.ULTIMATE)


rule "[AI/control]: Illari Primary":
    @Event eachPlayer
    @Team 1
    @Hero illari
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    wait(0.9)
    if ruleCondition:
        loop()


rule "[AI/control]: Illari Secondary":
    @Event eachPlayer
    @Team 1
    @Hero illari
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition ((sorted([player for player in getLivingPlayers(eventPlayer.getTeam()) if player != eventPlayer and distance(eventPlayer, player) <= 20 and player.getNormalizedHealth() < 0.5], lambda i: i.getHealth() * distance(eventPlayer, i)))[0]) != null
    @Condition eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) <= 80
    
    eventPlayer.startFacing(directionTowards(eventPlayer + Vector.UP * distance(eventPlayer, eventPlayer.getEyePosition()) + worldVector(vect(0, 0, 0), eventPlayer, Transform.ROTATION), ((sorted([player for player in getLivingPlayers(eventPlayer.getTeam()) if player != eventPlayer and distance(eventPlayer, player) <= 20 and player.getNormalizedHealth() < 1], lambda i: i.getHealth() * distance(eventPlayer, i)))[0]).getEyePosition()), 10000)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    waitUntil(eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) >= 45, 1.5)
    if ruleCondition:
        loop()
    eventPlayer.stopFacing()
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    wait(random.uniform(2.256, 5.5))


rule "[AI/control]: Illari Ability 1":
    @Event playerTookDamage
    @Team 1
    @Hero illari
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) != true
    
    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(WAIT_AI_THROTTLE_MIN)
    eventPlayer.stopForcingButton(Button.ABILITY_1)


rule "[AI/control]: Illari Ability 2":
    @Event eachPlayer
    @Team 1
    @Hero illari
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition (not eventPlayer.getAbilityCooldown(Button.ABILITY_2)) == true
    @Condition (not eventPlayer.isUsingAbility2()) == true
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.setProjectileSpeed(10)
    eventPlayer.setProjectileGravity(250)
    wait(WAIT_AI_THROTTLE_MIN)
    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(WAIT_AI_THROTTLE_MIN)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2), 5)
    eventPlayer.stopForcingButton(Button.ABILITY_2)
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 10, 5)
    if ruleCondition:
        loop()


rule "[AI/control]: Illari Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero illari
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    
    waitUntil(true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 25.5, 99999)
    eventPlayer.startForcingButton(Button.ULTIMATE)
    eventPlayer.startForcingButton(Button.JUMP)
    waitUntil(not eventPlayer.isUsingUltimate(), 4)
    eventPlayer.stopForcingButton(Button.JUMP)


rule "[AI/control]: Juno Primary":
    @Event eachPlayer
    @Team 1
    @Hero juno
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    if eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) != 0:
        goto lbl_0
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(0.88)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    lbl_0:
    wait(random.uniform(1, 4))
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "[AI/control]: Juno Ability 2":
    @Event eachPlayer
    @Team 1
    @Hero juno
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(WAIT_AI_THROTTLE_MIN)
    eventPlayer.stopForcingButton(Button.ABILITY_2)


rule "[AI/control]: Juno Jump":
    @Event eachPlayer
    @Team 1
    @Hero juno
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isDummy() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isOnGround() == true
    
    eventPlayer.forceButtonPress(Button.JUMP)
    wait(0.5)
    eventPlayer.forceButtonPress(Button.JUMP)
    wait(WAIT_AI_THROTTLE_MIN)
    if eventPlayer.getAbilityCooldown(Button.ABILITY_1) != 0:
        goto lbl_0
    eventPlayer.startForcingButton(Button.ABILITY_1)
    waitUntil(not eventPlayer.isUsingAbility1(), 4)
    eventPlayer.stopForcingButton(Button.ABILITY_1)
    lbl_0:


rule "[AI/control]: Juno Ultimate":
    @Event playerTookDamage
    @Team 1
    @Hero juno
    @Condition evalOnce(eventPlayer.isDummy()) != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    
    waitUntil(true and (((len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) and distance(eventPlayer, player) <= 10])) + (len([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player) and distance(eventPlayer, player) <= 15]))) >= 3), 99999)
    eventPlayer.forceButtonPress(Button.ULTIMATE)


