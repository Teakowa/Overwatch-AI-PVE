rule "[Zenyatta]: Transcendence":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.mov_speed_penalty = 0
    eventPlayer.mov_speed_buff += 25
    wait(0.16)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 6)
    eventPlayer.setHealingDealt(133.34)
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff)
    waitUntil(not eventPlayer.isUsingUltimate(), 6)
    eventPlayer.mov_speed_buff = 0
    eventPlayer.setHealingDealt(100)
    eventPlayer.setMoveSpeed(100)
