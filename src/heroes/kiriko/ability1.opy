rule "[kiriko]: swift step hp":
    @Event eachPlayer
    @Condition getPlayersOnHero(Hero.KIRIKO, eventPlayer.getTeam())[0].isHoldingButton(Button.ABILITY_1) == true
    @Condition getPlayersOnHero(Hero.KIRIKO, eventPlayer.getTeam())[0].isUsingAbility1() == true
    @Condition len(eventPlayer.kiriko_buff) < 5

    waitUntil(not eventPlayer.reset_pvar[3].isUsingAbility1() and len(getPlayersInRadius(eventPlayer.reset_pvar[3], 5, eventPlayer.getTeam(), LosCheck.SURFACES)) > 0 and eventPlayer.reset_pvar[3].hasStatus(Status.PHASED_OUT) == true, 0.5)
    wait(WAIT_SHORT_FRAME)
    #if eventPlayer.kiriko_buff == null:
    #        goto lbl_0
    #removeHealthPool(eventPlayer.kiriko_buff[0])
    lbl_0:
    if not eventPlayer.isAlive() or distance(eventPlayer.reset_pvar[3], eventPlayer) > 5 and not isInLoS(eventPlayer.reset_pvar[3], eventPlayer):
        goto lbl_1
    eventPlayer.addHealthPool(Health.NORMAL, 100, false, false)
    #eventPlayer.kiriko_buff = getLastCreatedHealthPool()
    lbl_1:
    eventPlayer.kiriko_buff.append(getLastCreatedHealthPool())
