#!mainFile "../../aramMain.opy"
#!optimizeStrict


playervar ram_block_damage
playervar ram_block_damage_hud
playervar ram_dmg_reduc
playervar ram_ult_damage_dealt

rule "[Ramattra]: Pain endures":
    @Event playerDealtFinalBlow
    @Hero ramattra
    @Condition eventPlayer.getUltCharge() != 100
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition (eventAbility == Button.ULTIMATE or eventAbility == Button.ABILITY_1) == true

    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 25)
    wait(0.3)

rule "[Ramattra] ult speed":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.mov_speed_buff += Ram_Annihilation[3]
    eventPlayer.setDamageDealt(100 + Ram_Annihilation[2])
    eventPlayer.setDamageReceived(100 - Ram_Annihilation[4])
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff - eventPlayer.mov_speed_penalty)
    eventPlayer.setKnockbackReceived(RAMATTRA_ARAM_KNOCKBACK_RECEIVED)
    waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    eventPlayer.mov_speed_buff = 0
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setKnockbackReceived(100)
    eventPlayer.setDamageDealt(100)
    wait(0.16)
    removeTankPassive()

rule "[Ramattra] ult start":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.getMaxHealthOfType(Health.NORMAL) + 50

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


rule "[Ramattra]: Pummel healing":
    @Event playerDealtDamage
    @Team 1
    @Hero ramattra
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventAbility == Button.ABILITY_1
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.getMaxHealthOfType(Health.NORMAL) + 50

    eventPlayer.ram_block_damage += eventDamage * 2.5
    wait(0.3)

rule "[Ramattra]: Pummel healing":
    @Event playerDealtDamage
    @Team 2
    @Hero ramattra
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventAbility == Button.ABILITY_1
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.getMaxHealthOfType(Health.NORMAL) + 50

    eventPlayer.ram_block_damage += eventDamage * 1.5
    wait(0.3)

rule "[Ramattra]: block":
    @Event playerTookDamage
    @Hero ramattra
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.ram_block_damage <= Ram_Annihilation[0]
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.getMaxHealthOfType(Health.NORMAL) + 50

    eventPlayer.ram_block_damage += eventDamage
    eventPlayer.hudText = "{0}/{1}".format(floor(eventPlayer.ram_block_damage), Ram_Annihilation[0])
    wait()

rule "[Ramattra]: block":
    @Event eachPlayer
    @Hero ramattra
    @Condition Ram_Annihilation[0] != 0
    @Condition eventPlayer.ram_block_damage != 0
    @Condition eventPlayer.ram_block_damage >= Ram_Annihilation[0]

    eventPlayer.addHealthPool(Health.NORMAL, Ram_Annihilation[0] if eventPlayer.ram_block_damage >= Ram_Annihilation[0] else eventPlayer.ram_block_damage, false, false)
    eventPlayer.ram_block_damage = 0
    eventPlayer.hudText = ""

rule "[Ramattra]: block HUD":
    @Event eachPlayer
    @Team 2
    @Hero ramattra
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer._reset_requested == false
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true

    waitUntil(eventPlayer.ram_block_damage == 0 or eventPlayer._reset_requested or eventPlayer.isInSpawnRoom(), 999999986991104)
    eventPlayer.hudText = ""

rule "[Ramattra]: Annihilation dmg reduc":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.ram_dmg_reduc == null

    startDamageModification(eventPlayer, getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).filter(lambda player: distance(eventPlayer, player) > 0.01), 25)
    eventPlayer.ram_dmg_reduc = getLastDamageModification()
    waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    stopDamageModification(eventPlayer.ram_dmg_reduc)
    eventPlayer.ram_dmg_reduc = null

