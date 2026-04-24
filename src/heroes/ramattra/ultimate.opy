#!optimizeStrict

rule "[Ramattra] ult speed":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer.isUsingUltimate() == true

    if abs(eventPlayer.mov_speed_buff) < abs(Ram_Annihilation[3]):
        eventPlayer.mov_speed_buff = Ram_Annihilation[3]
        applySignedMoveSpeed()
    eventPlayer.setDamageDealt(100 + Ram_Annihilation[5])
    eventPlayer.setDamageReceived(100 - Ram_Annihilation[4])
    eventPlayer.setKnockbackReceived(30)
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
    @Event playerDealtDamage
    @Hero ramattra
    #@Condition attacker.getHero() == Hero.RAMATTRA == true
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.getNormalizedHealth() != 1
    #@Condition eventAbility == Button.PRIMARY_FIRE == true

    #heal(eventPlayer, eventPlayer, Ram_Annihilation[2] * 15 * len(getPlayersInRadius(eventPlayer, 13, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES_AND_ENEMY_BARRIERS)))
    #wait(0.5)
    #playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, eventPlayer, 200)
    heal(eventPlayer, eventPlayer, eventDamage * Ram_Annihilation[1])
    wait(0.0016)

rule "[Ramattra]: Annihilation dmg reduc":
    @Event eachPlayer
    @Condition eventPlayer.reset_pvar[5].isUsingUltimate() == true
    @Condition len(getPlayersInRadius(eventPlayer, 13, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES)) > 0

    startDamageModification(eventPlayer, getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).filter(lambda player: distance(eventPlayer, player) > 13), 25)
    eventPlayer.ram_dmg_reduc = getLastDamageModification()
    wait(1)
    if ruleCondition:
        loop()
    #waitUntil(not eventPlayer.reset_pvar[5].isUsingUltimate() or distance(eventPlayer, eventPlayer.reset_pvar[5].getPosition()) <= 13, 120)
    stopDamageModification(eventPlayer.ram_dmg_reduc)
    eventPlayer.ram_dmg_reduc = null
