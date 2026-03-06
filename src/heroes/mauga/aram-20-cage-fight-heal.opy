rule "[Mauga]: Cage Fight heal":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.mauga_berserker_soul != true
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition (len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer, player) <= 7 and player.hasStatus(Status.ROOTED)])) > 0
    
    eventPlayer.startHealingOverTime(eventPlayer, 2, 120 * (len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer, player) <= 7 and player.hasStatus(Status.ROOTED)])))
    wait(1.996)
    if ruleCondition:
        loop()
