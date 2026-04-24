#!optimizeStrict

rule "[AI/control]: Pharah Primary":
    @Event eachPlayer
    @Team 1
    @Hero pharah
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(max(getAverageServerLoad() / 1000, 1))
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)



rule "[AI/control]: Pharah Secondary":
    @Event playerTookDamage
    @Team 1
    @Hero pharah
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    wait(4)



rule "[AI/control]: Pharah Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero pharah
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.ABILITY_1)



rule "[AI/control]: Pharah Ability 2":
    @Event eachPlayer
    @Team 1
    @Hero pharah
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.ABILITY_2)
    wait(max(getAverageServerLoad() / 1000, WAIT_AI_THROTTLE_MIN))
    eventPlayer.stopForcingButton(Button.ABILITY_2)



rule "[AI/control]: Pharah Jump":
    @Event eachPlayer
    @Team 1
    @Hero pharah
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.botTarget != null
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) == true]) > 0
    
    eventPlayer.startForcingButton(Button.JUMP)
    wait(max(getAverageServerLoad() / 1000, 0.333))
    eventPlayer.stopForcingButton(Button.JUMP)
    wait(0.167)
    while eventPlayer.isInAir():
        eventPlayer.startForcingButton(Button.JUMP)
        wait(max(getAverageServerLoad() / 1000, 0.333))
        eventPlayer.stopForcingButton(Button.JUMP)
        wait(max(getAverageServerLoad() / 1000, 0.333))
    wait(1.167)
    loop()



rule "[AI/control]: Pharah Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero pharah
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.isAlive() == true
    
    waitUntil(true and distance(eventPlayer.getPosition(), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 10, 99999)
    eventPlayer.startForcingButton(Button.ULTIMATE)



