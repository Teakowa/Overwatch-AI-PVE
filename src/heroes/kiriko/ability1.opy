#!optimizeStrict

rule "[Kiriko]: Swift Step":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0

    resetStatuses()
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, KIRIKO_ABILITY1_LINE_9_INVINCIBLE_DURATION)
    eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, KIRIKO_ABILITY1_LINE_10_PHASED_OUT_DURATION)

rule "[kiriko]: remove swift step hp":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.kiriko_buff != []

    wait(3, Wait.ABORT_WHEN_FALSE)
    removeHealthPool(eventPlayer.kiriko_buff[0])
    eventPlayer.kiriko_buff.remove(eventPlayer.kiriko_buff[0])
    if len(eventPlayer.kiriko_buff) != 0:
        loop()
    eventPlayer.kiriko_buff = []

rule "[kiriko]: swift step hp":
    @Event eachPlayer
    @Condition getPlayersOnHero(Hero.KIRIKO, eventPlayer.getTeam())[0].isHoldingButton(Button.ABILITY_1) == true
    @Condition getPlayersOnHero(Hero.KIRIKO, eventPlayer.getTeam())[0].isUsingAbility1() == true
    @Condition len(eventPlayer.kiriko_buff) < 5

    waitUntil(not eventPlayer.reset_pvar[3].isUsingAbility1() and len(getPlayersInRadius(eventPlayer.reset_pvar[3], KIRIKO_ABILITY1_LINE_30_RADIUS, eventPlayer.getTeam(), LosCheck.SURFACES)) > 0 and eventPlayer.reset_pvar[3].hasStatus(Status.PHASED_OUT) == true, 0.5)
    wait(WAIT_SHORT_FRAME)
    #if eventPlayer.kiriko_buff == null:
    #        goto lbl_0
    #removeHealthPool(eventPlayer.kiriko_buff[0])
    lbl_0:
    if not eventPlayer.isAlive() or distance(eventPlayer.reset_pvar[3], eventPlayer) > 5 and not isInLoS(eventPlayer.reset_pvar[3], eventPlayer):
        goto lbl_1
    eventPlayer.addHealthPool(Health.NORMAL, KIRIKO_ABILITY1_LINE_38_NORMAL_HEALTH_POOL_AMOUNT, false, false)
    #eventPlayer.kiriko_buff = getLastCreatedHealthPool()
    lbl_1:
    eventPlayer.kiriko_buff.append(getLastCreatedHealthPool())
