rule "[Ramattra]: Pummel Knockback":
    @Event playerDealtDamage
    @Hero ramattra
    @Condition eventAbility == Button.ABILITY_1
    
    victim.applyImpulse(directionFromAngles(horizontalAngleOfDirection(victim.getPosition() - attacker.getPosition()), -20), 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    victim.applyImpulse(Vector.UP, 2.5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    victim.setEnvironmentalKillCreditor(attacker)
    wait(0.5)
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
    waitUntil(not eventPlayer.isUsingUltimate() or eventPlayer.isDead(), WAIT_TIMEOUT_FOREVER)
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
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.custom_hp_pvar[0] + 50
    
    eventPlayer.ram_block_damage += 50
    eventPlayer.hudText = "{0}/{1}".format(floor(eventPlayer.ram_block_damage), Ram_Annihilation[0])
    wait(1.16)
    if ruleCondition:
        loop()
rule "[Ramattra] ult healing":
    @Event playerDealtDamage
    @Hero ramattra
    #@Condition attacker.getHero() == Hero.RAMATTRA == true
    @Condition attacker.isUsingUltimate() == true
    @Condition attacker.getHealth() < attacker.getMaxHealth()
    #@Condition eventAbility == Button.PRIMARY_FIRE == true
    
    #heal(eventPlayer, eventPlayer, Ram_Annihilation[2] * 15 * len(getPlayersInRadius(eventPlayer, 13, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES_AND_ENEMY_BARRIERS)))
    #wait(0.5)
    #playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, eventPlayer, 200)
    heal(attacker, attacker, eventDamage * Ram_Annihilation[1])
    wait(0.0016)
rule "[Ramattra]: Pummel healing":
    @Event playerDealtDamage
    @Team 1
    @Hero ramattra
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventAbility == Button.ABILITY_1
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.custom_hp_pvar[0] + 50
    
    eventPlayer.ram_block_damage += eventDamage * 2.5
    wait(0.3)
rule "[Ramattra]: Pummel healing":
    @Event playerDealtDamage
    @Team 2
    @Hero ramattra
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventAbility == Button.ABILITY_1
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.custom_hp_pvar[0] + 50
    
    eventPlayer.ram_block_damage += eventDamage * 1.5
    eventPlayer.hudText = "{0}/{1}".format(floor(eventPlayer.ram_block_damage), Ram_Annihilation[0])
    wait(0.3)
rule "[Ramattra]: Pain endures":
    @Event playerDealtFinalBlow
    @Hero ramattra
    @Condition eventPlayer.getUltCharge() != 100
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition (eventAbility == Button.ULTIMATE or eventAbility == Button.ABILITY_1) == true
    
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + 25)
    wait(0.3)
rule "[Ramattra]: block":
    @Event playerTookDamage
    @Hero ramattra
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.ram_block_damage <= Ram_Annihilation[0]
    @Condition eventPlayer.getHealthOfType(Health.NORMAL) <= eventPlayer.custom_hp_pvar[0] + 50
    
    eventPlayer.ram_block_damage += eventDamage
    eventPlayer.hudText = "{0}/{1}".format(floor(eventPlayer.ram_block_damage), Ram_Annihilation[0])
rule "[Ramattra]: block HP":
    @Event eachPlayer
    @Hero ramattra
    @Condition Ram_Annihilation[0] != 0
    @Condition eventPlayer.ram_block_damage != 0
    @Condition eventPlayer.ram_block_damage >= Ram_Annihilation[0]
    
    eventPlayer.addHealthPool(Health.NORMAL, Ram_Annihilation[0] if eventPlayer.ram_block_damage >= Ram_Annihilation[0] else eventPlayer.ram_block_damage, false, false)
    eventPlayer.ram_block_damage = 0
    eventPlayer.hudText = ""
    #if eventPlayer.getTeam() == Team.2:
    #        goto lbl_0
    #eventPlayer.startHealingOverTime(eventPlayer, 5, eventPlayer.getMaxHealth() * 0.25)
    lbl_0:
rule "[Ramattra]: block HUD":
    @Event eachPlayer
    @Team 2
    @Hero ramattra
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.reset_pvar[0] == false
    @Condition eventPlayer.ram_block_damage > 0
    
    #hudText(eventPlayer, null, "\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r", "{0}/{1}".format(floor(eventPlayer.ram_block_damage), Ram_Annihilation[0]), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    #eventPlayer.ram_block_damage_hud = getLastCreatedText()
    waitUntil(eventPlayer.ram_block_damage == 0 or eventPlayer.reset_pvar[0] or eventPlayer.isInSpawnRoom(), WAIT_TIMEOUT_FOREVER)
    eventPlayer.hudText = ""
    #destroyHudText(eventPlayer.ram_block_damage_hud)
