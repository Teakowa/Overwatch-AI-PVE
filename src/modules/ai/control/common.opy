#!optimizeStrict

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
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.botTarget != null
    
    botAim2Target()



