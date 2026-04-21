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

rule "[JunkerQueen]: Taunt enemies":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.unaffected != true
    @Condition eventPlayer.taunt == true
    @Condition (eventPlayer.getHero() == Hero.ORISA and (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate())) == false
    @Condition (eventPlayer.getHero() == Hero.MAUGA and eventPlayer.isUsingAbility1()) == false
    @Disabled
    
    bigMessage(eventPlayer, "嘲讽")
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), getPlayersOnHero(Hero.JUNKER_QUEEN, getOppositeTeam(eventPlayer.getTeam()))[0].getEyePosition()), 270)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    disableAllAbilities()
    waitUntil(eventPlayer.isDead() or not eventPlayer.taunt or eventPlayer.hasStatus(Status.PHASED_OUT), 2)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    enableAllAbilities()
    eventPlayer.stopFacing()
    eventPlayer.taunt = false
