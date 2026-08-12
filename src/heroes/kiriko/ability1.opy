#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Kiriko]: Swift Step":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0

    resetStatuses()
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, KIRIKO_ABILITY1_INVINCIBLE_DURATION)
    eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, KIRIKO_ABILITY1_PHASED_OUT_DURATION)

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
    @Hero kiriko
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.isUsingAbility1() == true

    waitUntil(not eventPlayer.isUsingAbility1() and len(getPlayersInRadius(eventPlayer, KIRIKO_ABILITY1_RADIUS, eventPlayer.getTeam(), LosCheck.SURFACES)) > 0 and eventPlayer.hasStatus(Status.PHASED_OUT) == true, 0.5)
    wait(WAIT_SHORT_FRAME)
    for eventPlayer.kiriko_step_idx in range(len(getPlayers(eventPlayer.getTeam()))):
        if getPlayers(eventPlayer.getTeam())[eventPlayer.kiriko_step_idx].isAlive() == true and (distance(eventPlayer, getPlayers(eventPlayer.getTeam())[eventPlayer.kiriko_step_idx]) <= KIRIKO_ABILITY1_RADIUS or isInLoS(eventPlayer, getPlayers(eventPlayer.getTeam())[eventPlayer.kiriko_step_idx])) and len(getPlayers(eventPlayer.getTeam())[eventPlayer.kiriko_step_idx].kiriko_buff) < 5:
            getPlayers(eventPlayer.getTeam())[eventPlayer.kiriko_step_idx].addHealthPool(Health.NORMAL, KIRIKO_ABILITY1_NORMAL_HEALTH_POOL_AMOUNT, false, false)
            getPlayers(eventPlayer.getTeam())[eventPlayer.kiriko_step_idx].kiriko_buff.append(getLastCreatedHealthPool())
