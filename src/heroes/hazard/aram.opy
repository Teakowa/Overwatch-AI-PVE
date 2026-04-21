rule "[Hazard]: Spike Guard cd":

    @Event playerDealtDamage

    @Hero hazard

    @Condition eventAbility == Button.ABILITY_1

    @Condition HazardBuff[0] != 0

    @Condition victim.hasStatus(Status.INVINCIBLE) != true

    @Condition victim.zarya_buff[1] == null

    damage(victim, attacker, victim.getMaxHealth() * HazardBuff[0])

    wait(0.032)

rule "[Hazard]: Spike Guard get Ultimate and heal":

    @Event playerTookDamage

    @Hero hazard

    @Condition eventPlayer.hazard_using_ability_sec == true

    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + (HazardBuff[1] if eventPlayer.getTeam() == Team.2 else HazardBuff[1] * 2.5))

    heal(eventPlayer, eventPlayer, eventDamage / 0.35 * HazardBuff[2])

    wait(min(0.16, getAverageServerLoad() / 100))

# hazard aram-mode overlay

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

rule "[Hazard]: Spike Guard using tracking":

    @Event eachPlayer

    @Hero hazard

    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true

    eventPlayer.hazard_using_ability_sec = true

    waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), 12)

    eventPlayer.hazard_using_ability_sec = false
