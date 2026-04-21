rule "[Zenyatta]: Transcendence":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isUsingUltimate() == true

    if abs(eventPlayer.mov_speed_buff) < abs(25):
        eventPlayer.mov_speed_buff = 25
        applySignedMoveSpeed()
    wait(WAIT_SHORT_FRAME)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 6)
    eventPlayer.setHealingDealt(133.34)
    waitUntil(not eventPlayer.isUsingUltimate() or eventPlayer.isDead(), 6)
    if eventPlayer.isDead() != true:
        if eventPlayer.mov_speed_buff == 25:
            eventPlayer.mov_speed_buff = 0
            applySignedMoveSpeed()
    eventPlayer.setHealingDealt(100)
