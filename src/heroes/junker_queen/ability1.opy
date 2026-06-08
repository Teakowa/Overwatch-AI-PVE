#!optimizeStrict

rule "[JunkerQueen]: Commanding Shout taunt enemies":
    @Event eachPlayer
    @Hero junkerQueen
    @Condition eventPlayer.isUsingAbility1() == true

    if eventPlayer.junker_queen_buff == null:
        goto lbl_0
    removeHealthPool(eventPlayer.junker_queen_buff)
    lbl_0:
    wait(0.096)
    eventPlayer.addHealthPool(Health.NORMAL, 500 * len([player for player in getPlayersInRadius(eventPlayer, JUNKER_QUEEN_ABILITY1_RADIUS, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES)]), false, false)
    eventPlayer.junker_queen_buff = getLastCreatedHealthPool()
    wait(6)
    removeHealthPool(eventPlayer.junker_queen_buff)
