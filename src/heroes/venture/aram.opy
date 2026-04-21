# venture aram-only burrow speed and healing

rule "[Venture] Burrow speed and healing":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.mov_speed_buff = 56
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff)
    waitUntil(not eventPlayer.isUsingAbility1(), 99999)
    eventPlayer.mov_speed_buff = 0
    eventPlayer.setMoveSpeed(100)
