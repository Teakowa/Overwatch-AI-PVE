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

rule "[Zarya]: Projected Barrier Shields":
    @Event eachPlayer
    @Condition eventPlayer.getHero() != Hero.ZARYA
    @Condition (eventPlayer.isAlive() and eventPlayer.zarya_barrier_shields[0]) == true

    if eventPlayer.mauga_berserker_soul == true:
        goto lbl_0
    resetStatuses()
    lbl_0:
    eventPlayer.zarya_barrier_shields[0] = false
    if eventPlayer.zarya_barrier_shields[1] == null:
        goto lbl_1
    removeHealthPool(eventPlayer.zarya_barrier_shields[1])
    lbl_1:
    eventPlayer.addHealthPool(Health.NORMAL, 50, false, false)
    eventPlayer.zarya_barrier_shields[1] = getLastCreatedHealthPool()
    wait(3, Wait.RESTART_WHEN_TRUE)
    removeHealthPool(eventPlayer.zarya_barrier_shields[1])
    eventPlayer.zarya_barrier_shields[1] = null

#!include "ability2.opy"
