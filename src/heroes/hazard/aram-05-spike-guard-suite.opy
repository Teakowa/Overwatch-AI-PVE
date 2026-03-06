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
