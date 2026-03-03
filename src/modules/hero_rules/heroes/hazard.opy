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
rule "[Ramattra]: Annihilation dmg reduc":
    @Event eachPlayer
    @Condition eventPlayer.reset_pvar[5].isUsingUltimate() == true
    @Condition distance(eventPlayer, eventPlayer.reset_pvar[5].getPosition()) > 13
    
    startDamageModification(eventPlayer.reset_pvar[5], eventPlayer, 25)
    eventPlayer.ram_dmg_reduc = getLastDamageModification()
    waitUntil(not eventPlayer.reset_pvar[5].isUsingUltimate() or distance(eventPlayer, eventPlayer.reset_pvar[5].getPosition()) <= 13, 120)
    stopDamageModification(eventPlayer.ram_dmg_reduc)
    eventPlayer.ram_dmg_reduc = null
