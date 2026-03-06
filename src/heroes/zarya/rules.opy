#!include "shared/10-projected-barrier-target.opy"
rule "[Zarya]: will to win":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.reset_pvar[0] == false
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.getHero() == Hero.ZARYA
    @Condition ZaryaBuff[2] == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.zarya_buff[0] == true
    @Condition eventPlayer.getHealth() <= eventPlayer.getMaxHealth() * 0.3
    
    bigMessage(eventPlayer, "胜利意志！")
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 1)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    eventPlayer.startHealingOverTime(eventPlayer, ZaryaBuff[3], ZaryaBuff[4])
    eventPlayer.zarya_buff[1] = getLastHealingOverTimeId()
    waitUntil(eventPlayer.isDead(), ZaryaBuff[3])
    stopHealingOverTime(eventPlayer.zarya_buff[1])
    eventPlayer.zarya_buff[0] = false
    eventPlayer.zarya_buff[1] = null
