#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Ramattra]: Pain endures":
    @Event playerDealtFinalBlow
    @Hero ramattra
    @Condition eventPlayer.getUltCharge() != 100
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition (eventAbility == Button.ULTIMATE or eventAbility == Button.ABILITY_1 or eventAbility == Button.MELEE) == true

    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 25)
    wait(0.3)

rule "[Ramattra] ult speed":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.isUsingUltimate() == true

    if abs(eventPlayer.mov_speed_buff) < abs(Ram_Annihilation[3]):
        eventPlayer.mov_speed_buff = Ram_Annihilation[3]
        applySignedMoveSpeed()
    eventPlayer.setDamageDealt(100 + Ram_Annihilation[2])
    eventPlayer.setDamageReceived(100 - Ram_Annihilation[4])
    eventPlayer.setKnockbackReceived(RAMATTRA_ULTIMATE_KNOCKBACK_RECEIVED)
    waitUntil(not eventPlayer.isUsingUltimate() or eventPlayer.isDead(), Math.INFINITY)
    if eventPlayer.isDead():
        goto lbl_0
    if eventPlayer.mov_speed_buff == Ram_Annihilation[3]:
        eventPlayer.mov_speed_buff = 0
        applySignedMoveSpeed()
    lbl_0:
    eventPlayer.setDamageReceived(100)
    eventPlayer.setKnockbackReceived(100)
    eventPlayer.setDamageDealt(100)
    wait(WAIT_SHORT_FRAME)
    #removeTankPassive()

rule "[Ramattra] ult start":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= 325

    eventPlayer.ram_block_damage += 50
    eventPlayer.hudText = "{0}/{1}".format(floor(eventPlayer.ram_block_damage), Ram_Annihilation[0])
    wait(1.16)
    if ruleCondition:
        loop()

rule "[Ramattra] ult healing":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.getNormalizedHealth() != 1

    eventPlayer.ram_ult_damage_dealt = eventPlayer.getHeroStatistic(Hero.RAMATTRA, HeroStat.DAMAGE_DEALT)
    wait(1)
    if ruleCondition:
        heal(eventPlayer, eventPlayer, (eventPlayer.getHeroStatistic(Hero.RAMATTRA, HeroStat.DAMAGE_DEALT) - eventPlayer.ram_ult_damage_dealt) * Ram_Annihilation[1])
        eventPlayer.ram_ult_damage_dealt = eventPlayer.getHeroStatistic(Hero.RAMATTRA, HeroStat.DAMAGE_DEALT)
        loop()

rule "[Ramattra]: Annihilation dmg reduc":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.ram_dmg_reduc == null

    startDamageModification(eventPlayer, getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).filter(lambda player: distance(eventPlayer, player) > 13), 25)
    eventPlayer.ram_dmg_reduc = getLastDamageModification()
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    stopDamageModification(eventPlayer.ram_dmg_reduc)
    eventPlayer.ram_dmg_reduc = null
