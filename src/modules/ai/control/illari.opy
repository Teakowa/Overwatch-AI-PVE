#!optimizeStrict

rule "[AI/control]: Illari Primary":
    @Event eachPlayer
    @Team 1
    @Hero illari
    @Condition eventPlayer.isDummy() != false
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
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) <= 80
    @Condition len([player for player in getLivingPlayers(eventPlayer.getTeam()) if player != eventPlayer and distance(eventPlayer, player) <= 20 and player.getNormalizedHealth() < 0.5]) > 0
    
    eventPlayer.startFacing(directionTowards(eventPlayer + Vector.UP * distance(eventPlayer, eventPlayer.getEyePosition()) + worldVector(vect(0, 0, 0), eventPlayer, Transform.ROTATION), ((sorted([player for player in getLivingPlayers(eventPlayer.getTeam()) if player != eventPlayer and distance(eventPlayer, player) <= 20 and player.getNormalizedHealth() < 1], lambda i: i.getHealth() * distance(eventPlayer, i)))[0]).getEyePosition()), 10000)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    waitUntil(eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) >= 45, 1.5)
    eventPlayer.stopFacing()
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    wait(random.uniform(2.256, 5.5))
    if ruleCondition:
        loop()



rule "[AI/control]: Illari Ability 1":
    @Event playerTookDamage
    @Team 1
    @Hero illari
    @Condition eventPlayer.isDummy() != false
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
    @Condition eventPlayer.isDummy() != false
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
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    
    waitUntil(true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 25.5, 99999)
    eventPlayer.startForcingButton(Button.ULTIMATE)
    eventPlayer.startForcingButton(Button.JUMP)
    waitUntil(not eventPlayer.isUsingUltimate(), 4)
    eventPlayer.stopForcingButton(Button.JUMP)



