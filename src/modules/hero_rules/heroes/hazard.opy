rule "[Hazard]: Violent Leap kiil reset cooldown":
    @Event playerEarnedElimination
    @Hero hazard
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)


rule "[Hazard]: Violent Leap HP":
    @Event eachPlayer
    @Hero hazard
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 3
    
    if eventPlayer.hazard_hp_id == null:
        goto lbl_0
    removeHealthPool(eventPlayer.hazard_hp_id)
    lbl_0:
    eventPlayer.addHealthPool(Health.NORMAL, 125, false, false)
    eventPlayer.hazard_hp_id = getLastCreatedHealthPool()
    wait(3, Wait.RESTART_WHEN_TRUE)
    removeHealthPool(eventPlayer.hazard_hp_id)
    eventPlayer.hazard_hp_id = null


rule "[Hazard]: Spike Guard cd":
    @Event playerDealtDamage
    @Hero hazard
    @Condition attacker.getHero() == Hero.HAZARD
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition HazardBuff[0] != 0
    
    damage(victim, attacker, HazardBuff[0] * eventDamage - eventDamage)


rule "[Hazard]: stun Downpour":
    @Event playerTookDamage
    @Condition HazardBuff[10] == true
    @Condition eventAbility == Button.ULTIMATE
    @Condition attacker.getHero() == Hero.HAZARD
    @Condition attacker.getUltCharge() < HazardBuff[11] * 6
    @Disabled
    
    if attacker.getUltCharge() > HazardBuff[11] * 6:
        goto lbl_0
    attacker.setUltCharge(attacker.getUltCharge() + HazardBuff[11])
    lbl_0:


rule "[Hazard]: Spike Guard get Ultimate and heal":
    @Event playerTookDamage
    @Hero hazard
    @Condition eventPlayer.hazard_using_ability_sec == true
    
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + (HazardBuff[1] if eventPlayer.getTeam() == Team.2 else HazardBuff[1] * 1.15))
    heal(eventPlayer, eventPlayer, eventDamage / 0.35 * (HazardBuff[2] if eventPlayer.getTeam() == Team.2 else 0.5))
    wait(max(0.5, getAverageServerLoad() / 100))


rule "[Hazard]: Spike Guard using tracking":
    @Event eachPlayer
    @Hero hazard
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    eventPlayer.hazard_using_ability_sec = true
    waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 12)
    eventPlayer.hazard_using_ability_sec = false


rule "[Orisa]: stun when ult":
    @Event playerDealtKnockback
    @Hero orisa
    @Condition eventAbility == Button.ULTIMATE
    @Condition victim.unaffected != true
    
    victim.setStatusEffect(attacker, Status.STUNNED, 1.25)


rule "[Orisa]: stun when ult":
    @Event playerDealtKnockback
    @Hero orisa
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim.isAlive() == true
    @Condition victim.unaffected != true
    
    wait(0.3, Wait.ABORT_WHEN_FALSE)
    if victim.zarya_buff[1] != null:
        goto lbl_0
    victim.orisa_buff = true
    lbl_0:
    victim.mov_speed_penalty += Orisa_Fortify[2]


rule "[Orisa]: fly":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()


rule "[Orisa]: speed":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.unaffected != true
    @Condition eventPlayer.orisa_buff == true
    
    eventPlayer.setMoveSpeed(100 - eventPlayer.mov_speed_penalty + eventPlayer.mov_speed_buff)
    waitUntil(not eventPlayer.orisa_buff or eventPlayer.unaffected or eventPlayer.hasStatus(Status.INVINCIBLE) or eventPlayer.hasStatus(Status.PHASED_OUT), 2)
    eventPlayer.mov_speed_penalty = 0
    eventPlayer.setMoveSpeed(100)
    eventPlayer.orisa_buff = false


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


rule "[Ramattra]: Annihilation dmg reduc":
    @Event eachPlayer
    @Condition eventPlayer.reset_pvar[5].isUsingUltimate() == true
    @Condition distance(eventPlayer, eventPlayer.reset_pvar[5].getPosition()) > 13
    
    startDamageModification(eventPlayer.reset_pvar[5], eventPlayer, 25)
    eventPlayer.ram_dmg_reduc = getLastDamageModification()
    waitUntil(not eventPlayer.reset_pvar[5].isUsingUltimate() or distance(eventPlayer, eventPlayer.reset_pvar[5].getPosition()) <= 13, 120)
    stopDamageModification(eventPlayer.ram_dmg_reduc)
    eventPlayer.ram_dmg_reduc = null


