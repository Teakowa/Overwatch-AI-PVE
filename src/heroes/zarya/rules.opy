#!optimizeStrict

#!mainFile "../../main.opy"

playervar zarya_barrier_shields

rule "[Zarya]: will to win":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.reset_pvar[0] == false
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.getHero() == Hero.ZARYA
    @Condition ZaryaBuff[2] == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.zarya_buff[0] == true
    @Condition eventPlayer.getHealth().isAtMostPercentOf(30, eventPlayer.getMaxHealth())

    bigMessage(eventPlayer, "胜利意志！")
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, ZARYA_RULES_INVINCIBLE_DURATION)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, ZARYA_RULES_PHASED_OUT_DURATION)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    heal(eventPlayer, eventPlayer, ZaryaBuff[3] * ZaryaBuff[4])
    eventPlayer.zarya_buff[1] = true
    waitUntil(eventPlayer.isDead(), ZaryaBuff[3])
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
    eventPlayer.addHealthPool(Health.NORMAL, ZARYA_RULES_NORMAL_HEALTH_POOL_AMOUNT, false, false)
    eventPlayer.zarya_barrier_shields[1] = getLastCreatedHealthPool()
    wait(3, Wait.RESTART_WHEN_TRUE)
    removeHealthPool(eventPlayer.zarya_barrier_shields[1])
    eventPlayer.zarya_barrier_shields[1] = null
#!include "ability2.opy"
