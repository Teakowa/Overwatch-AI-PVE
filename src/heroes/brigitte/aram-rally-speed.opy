rule "[brigitte/rally.opy]: Rally 30% speed boost":
    @Event eachPlayer
    @Hero brigitte
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.mov_speed_buff += 13.043
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff)
    waitUntil(not eventPlayer.isUsingUltimate(), 10)
    eventPlayer.mov_speed_buff = 0
    eventPlayer.setMoveSpeed(100)
