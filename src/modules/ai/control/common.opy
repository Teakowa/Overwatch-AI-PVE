#!mainFile "../../../main.opy"
#!optimizeStrict

rule "[AI]: Target in line of sight":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getHero() in CustomAIArray.concat([Hero.REAPER, Hero.KIRIKO, Hero.MAUGA, Hero.SOJOURN, Hero.GENJI, Hero.TRACER]) == true

    if len(getPlayersInRadius(eventPlayer, 22, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES)) == 0:
        eventPlayer.botTemp = []
        eventPlayer.botTarget = null
        goto lbl_0

    eventPlayer.botTemp = [
        player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam()))
        if player.hasSpawned()
        and not player.hasStatus(Status.INVINCIBLE)
        and not player.hasStatus(Status.PHASED_OUT)
        and not (player.getHero() == Hero.ORISA and player.isUsingAbility1())
        and not (player.getHero() == Hero.GENJI and player.isUsingAbility2())
        and not (player.getHero() == Hero.DOOMFIST and player.isUsingAbility2())
        and isInLoS(eventPlayer, player)
    ]
    if not eventPlayer.botTemp:
        eventPlayer.botTarget = null
        goto lbl_0
    if len(eventPlayer.botTemp) > 1:
        eventPlayer.botTemp = sorted(eventPlayer.botTemp, lambda player: player.getHealth() * distance(eventPlayer, player))
    eventPlayer.botTarget = eventPlayer.botTemp.first()
    lbl_0:
    wait(0.512)
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
