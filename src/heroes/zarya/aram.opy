#!mainFile "../../aramMain.opy"
#!optimizeStrict


playervar zarya_barrier_shields

rule "[Zarya]: Projected Barrier Target":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isUsingAbility2() == true

    [i for i in sorted(getLivingPlayers(eventPlayer.getTeam()), lambda player: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getPosition(), player.getPosition()))) if i.hasStatus(Status.INVINCIBLE)][0].zarya_barrier_shields[0] = true

rule "[Zarya]: Projected Barrier Shields":
    @Event eachPlayer
    @Condition not isHero(eventPlayer, Hero.ZARYA)
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
    eventPlayer.addHealthPool(Health.NORMAL, ZaryaBuff[0], false, false)
    eventPlayer.zarya_barrier_shields[1] = getLastCreatedHealthPool()
    wait(3, Wait.RESTART_WHEN_TRUE)
    removeHealthPool(eventPlayer.zarya_barrier_shields[1])
    eventPlayer.zarya_barrier_shields[1] = null

rule "[Zarya]: will to win":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer._reset_requested == false
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition isHero(eventPlayer, Hero.ZARYA)
    @Condition ZaryaBuff[1] == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.zarya_buff[0] == true
    @Condition eventPlayer.healthAtMostPercent(30)

    bigMessage(eventPlayer, "胜利意志！")
    eventPlayer.setStatusEffect(null, Status.UNKILLABLE, ZARYA_ARAM_UNKILLABLE_DURATION)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, ZARYA_ARAM_INVINCIBLE_DURATION)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, ZARYA_ARAM_PHASED_OUT_DURATION)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    heal(eventPlayer, eventPlayer, ZaryaBuff[2] * ZaryaBuff[3])
    eventPlayer.zarya_buff[1] = true
    wait(15)
    eventPlayer.zarya_buff[0] = false
    eventPlayer.zarya_buff[1] = null
