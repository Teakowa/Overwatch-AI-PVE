rule "[JunkerQueen]: Commanding Shout taunt enemies":
    @Event eachPlayer
    @Hero junkerQueen
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition (len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) and distance(eventPlayer, player) <= 15])) > 0
    
    if eventPlayer.junker_queen_buff == null:
        goto lbl_0
    removeHealthPool(eventPlayer.junker_queen_buff)
    lbl_0:
    ([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player) and distance(eventPlayer, player) <= 15 and player.unaffected != true]).taunt = true
    wait(0.096)
    eventPlayer.addHealthPool(Health.NORMAL, 500 * (len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.taunt == true])), false, false)
    eventPlayer.junker_queen_buff = getLastCreatedHealthPool()
    wait(6)
    removeHealthPool(eventPlayer.junker_queen_buff)
