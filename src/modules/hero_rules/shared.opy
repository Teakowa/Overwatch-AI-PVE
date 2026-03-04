rule "[Player]: status reset":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition (eventPlayer.hasStatus(Status.INVINCIBLE) or eventPlayer.hasStatus(Status.PHASED_OUT) or eventPlayer.unaffected == true) == true
    @Condition eventPlayer.mauga_berserker_soul != true
    
    resetStatuses()
    wait(1)


rule "[Brigitte]: remove Rally provides permanent armor":
    @Event eachPlayer
    @Condition Brigitte[2] != 0
    @Condition getPlayersOnHero(Hero.BRIGITTE, eventPlayer.getTeam())[0].isUsingUltimate() == true
    
    waitUntil(not eventPlayer.reset_pvar[1].isUsingUltimate() and eventPlayer.brig_rally_armor_id != [], 60)
    wait(2)
    removeHealthPool(eventPlayer.brig_rally_armor_id[0])
    eventPlayer.brig_rally_armor_id.remove(eventPlayer.brig_rally_armor_id[0])
    if len(eventPlayer.brig_rally_armor_id) != 0:
        loop()
    eventPlayer.brig_rally_armor_id = []
    eventPlayer.dmg_reduction = 0
    eventPlayer.hudText = ""
    eventPlayer.setDamageReceived(100)


rule "[Brigitte]Rally provides permanent armor to self":
    @Event eachPlayer
    @Hero brigitte
    @Condition Brigitte[2] != 0
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition len(eventPlayer.brig_rally_armor_id) < 9
    @Condition getAverageServerLoad() < ANTI_CRASH_DEACTIVATE_PERCENT
    
    eventPlayer.dmg_reduction += 1.5
    eventPlayer.setDamageReceived(100 - eventPlayer.dmg_reduction)
    eventPlayer.hudText = "受到伤害减免：{0}%".format(eventPlayer.dmg_reduction)
    eventPlayer.addHealthPool(Health.ARMOR, Brigitte[2], false, false)
    eventPlayer.brig_rally_armor_id.append(getLastCreatedHealthPool())
    wait(0.5)
    if ruleCondition:
        loop()


rule "[Brigitte]Rally provides permanent armor to allies":
    @Event eachPlayer
    @Team 2
    @Condition getPlayersOnHero(Hero.BRIGITTE, eventPlayer.getTeam()).isUsingUltimate() == true
    @Condition distance(eventPlayer, getPlayersOnHero(Hero.BRIGITTE, eventPlayer.getTeam())) <= 8.5
    @Condition eventPlayer.getHero() != Hero.BRIGITTE
    @Condition len(eventPlayer.brig_rally_armor_id) < 9
    @Condition getAverageServerLoad() < ANTI_CRASH_DEACTIVATE_PERCENT
    
    eventPlayer.addHealthPool(Health.ARMOR, Brigitte[2], false, false)
    eventPlayer.brig_rally_armor_id.append(getLastCreatedHealthPool())
    wait(0.5)
    if ruleCondition:
        loop()


rule "[Orisa]: Fortify provides 100 temporary armor":
    @Event eachPlayer
    @Hero orisa
    @Condition Orisa_Fortify[0] != 0
    #@Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition any([i == true for i in [eventPlayer.isUsingAbility1(), eventPlayer.isUsingUltimate()]]) == true
    
    eventPlayer.unaffected = true
    wait(0.096, Wait.ABORT_WHEN_FALSE)
    clearMoveSpeedDebuffs()
    eventPlayer.addHealthPool(Health.ARMOR, Orisa_Fortify[0], true, false)
    eventPlayer.orisa_fortify_armor_id = getLastCreatedHealthPool()
    if eventPlayer.isUsingAbility1() == true:
        waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    else:
        waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    removeHealthPool(eventPlayer.orisa_fortify_armor_id)
    eventPlayer.unaffected = false


rule "[Mauga]: Fortify provides 100 temporary armor":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.unaffected = true
    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    eventPlayer.unaffected = false


rule "[Mercy]: Valkyrie":
    @Event eachPlayer
    @Hero mercy
    @Condition MercyBuff[0] != 0
    @Condition eventPlayer.isUsingUltimate() == true
    
    getLivingPlayers(eventPlayer.getTeam()).startHealingOverTime(eventPlayer, 15, 45)
    eventPlayer.setDamageDealt(200)
    eventPlayer.setDamageReceived(100 - MercyBuff[0])
    waitUntil(not eventPlayer.isUsingUltimate(), 20)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setDamageDealt(100)


rule "【天使】女武神刷新复活冷却时间":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) != 0
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)

