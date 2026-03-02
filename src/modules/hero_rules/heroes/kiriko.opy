rule "[brigitte/rally.opy]: Rally 30% speed boost":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate() == true
    
    #30% movement speed buff during ralley
    eventPlayer.mov_speed_buff += 13.043
    eventPlayer.setMoveSpeed(min(max(100 + eventPlayer.mov_speed_buff, 20), 200))
    waitUntil(not eventPlayer.isUsingUltimate() or eventPlayer.isDead(), 10)
    if eventPlayer.isDead():
        goto lbl_0
    eventPlayer.mov_speed_buff -= 13.043
    eventPlayer.setMoveSpeed(min(max(100 + eventPlayer.mov_speed_buff, 20), 200))
    lbl_0:


rule "[Bot] PTP1":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasStatus(Status.FROZEN) == false
    @Condition eventPlayer.hasStatus(Status.ASLEEP) == false
    @Condition eventPlayer.hasStatus(Status.ROOTED) == false
    @Condition eventPlayer.hasStatus(Status.KNOCKED_DOWN) == false
    @Condition (getCurrentMap() in [Map.ROUTE66, Map.HAVANA, Map.CIRCUIT_ROYAL, Map.DORADO, Map.JUNKERTOWN, Map.RIALTO, Map.SHAMBALI_MONASTERY] or getCurrentMap() in [Map.BLIZZ_WORLD, Map.BLIZZ_WORLD_WINTER, Map.EICHENWALDE, Map.EICHENWALDE_HALLOWEEN, Map.HOLLYWOOD, Map.HOLLYWOOD_HALLOWEEN, Map.KINGS_ROW, Map.KINGS_ROW_WINTER, Map.MIDTOWN, Map.NUMBANI, Map.PARAISO]) == true
    @Condition (isInLoS(eventPlayer, getPayloadPosition()) != true and getPlayersInRadius(eventPlayer, 37.5, Team.2, LosCheck.SURFACES) != true and len(getPlayersOnObjective(Team.2)) == 0 and eventPlayer.isUsingUltimate() != true) == true
    @Condition (eventPlayer.isAlive() and getPayloadProgressPercentage() >= 5 and distance(eventPlayer, getPayloadPosition()) >= 5 and distance(eventPlayer, getPayloadPosition()) < 20) == true
    
    wait(2, Wait.ABORT_WHEN_FALSE)
    eventPlayer.teleport(getPayloadPosition() + vect(random.uniform(0, 1.5), 1.5, random.uniform(0, 1.5)))


rule "[Bot] ACC":
    @Event eachPlayer
    @Team 1
    @Condition getMatchTime() == 0
    @Condition (getCurrentMap() in [Map.ROUTE66, Map.HAVANA, Map.CIRCUIT_ROYAL, Map.DORADO, Map.JUNKERTOWN, Map.RIALTO, Map.SHAMBALI_MONASTERY] or getCurrentMap() in [Map.BLIZZ_WORLD, Map.BLIZZ_WORLD_WINTER, Map.EICHENWALDE, Map.EICHENWALDE_HALLOWEEN, Map.HOLLYWOOD, Map.HOLLYWOOD_HALLOWEEN, Map.KINGS_ROW, Map.KINGS_ROW_WINTER, Map.MIDTOWN, Map.NUMBANI, Map.PARAISO]) == true
    @Condition (isInLoS(eventPlayer, getPayloadPosition()) and eventPlayer.isAlive() and len(getPlayersOnObjective(Team.2)) >= 1 and len(getPlayersOnObjective(Team.1)) < 3 and getPayloadProgressPercentage() >= 2.5 and distance(eventPlayer, getPayloadPosition()) >= 2.5 and distance(eventPlayer, getPayloadPosition()) < 25) == true
    
    eventPlayer.startAcceleration(directionTowards(eventPlayer, getPayloadPosition()), 80, 3, Relativity.TO_WORLD)
    wait(2)
    if ruleCondition:
        loop()
    eventPlayer.stopAcceleration()


rule "[Kiriko]: Protection Suzu Clear Effect":
    @Event playerDealtHealing
    @Hero kiriko
    @Condition eventAbility == Button.ABILITY_2
    #@Condition healer.getHero() == Hero.KIRIKO == true
    @Condition healee.mauga_berserker_soul != true
    
    if healee != healer:
        goto lbl_0
    resetStatuses()
    lbl_0:
    healee.unaffected = true
    healee.setStatusEffect(healer, Status.INVINCIBLE, 1.8)
    healee.setStatusEffect(healer, Status.PHASED_OUT, 1.8)
    wait(1.8)
    healee.unaffected = false


rule "[Kiriko]: Swift Step":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0
    
    resetStatuses()
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 1.5)
    eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, 1.5)


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


rule "[Lifeweaver]: Life Grip Clear Effect":
    @Event playerReceivedHealing
    @Condition eventAbility == Button.ABILITY_2
    @Condition healer.getHero() == Hero.LIFEWEAVER == true
    @Condition eventPlayer.mauga_berserker_soul != true
    
    resetStatuses()
