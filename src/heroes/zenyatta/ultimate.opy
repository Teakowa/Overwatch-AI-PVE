#!optimizeStrict

rule "[Zenyatta]: Transcendence":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isUsingUltimate() == true

    if abs(eventPlayer.mov_speed_buff) < abs(25):
        eventPlayer.mov_speed_buff = 25
        applySignedMoveSpeed()
    wait(WAIT_SHORT_FRAME)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, ZENYATTA_ULTIMATE_PHASED_OUT_DURATION)
    eventPlayer.setHealingDealt(ZENYATTA_ULTIMATE_HEALING_DEALT)
    waitUntil(not eventPlayer.isUsingUltimate() or eventPlayer.isDead(), 6)
    if eventPlayer.isDead() != true:
        if eventPlayer.mov_speed_buff == 25:
            eventPlayer.mov_speed_buff = 0
            applySignedMoveSpeed()
    eventPlayer.setHealingDealt(100)
