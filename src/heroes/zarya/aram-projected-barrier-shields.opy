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
    eventPlayer.addHealthPool(Health.NORMAL, ZaryaBuff[0], false, false)
    eventPlayer.zarya_barrier_shields[1] = getLastCreatedHealthPool()
    wait(3, Wait.RESTART_WHEN_TRUE)
    removeHealthPool(eventPlayer.zarya_barrier_shields[1])
    eventPlayer.zarya_barrier_shields[1] = null
