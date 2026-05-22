#!optimizeStrict

rule "[JunkerQueen]: Commanding Shout taunt enemies":
    @Event eachPlayer
    @Hero junkerQueen
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition len(getPlayersInRadius(eventPlayer, 15, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES)) > 0

    if eventPlayer.junker_queen_buff == null:
        goto lbl_0
    removeHealthPool(eventPlayer.junker_queen_buff)
    lbl_0:
    ([player for player in getPlayersInRadius(eventPlayer, 15, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES) if player.unaffected != true]).taunt = true
    wait(0.096)
    eventPlayer.addHealthPool(Health.NORMAL, 500 * len([player for player in getPlayersInRadius(eventPlayer, 15, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES) if player.taunt == true]), false, false)
    eventPlayer.junker_queen_buff = getLastCreatedHealthPool()
    wait(6)
    removeHealthPool(eventPlayer.junker_queen_buff)
