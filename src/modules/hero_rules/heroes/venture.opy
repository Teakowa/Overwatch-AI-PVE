rule "[Venture] Burrow speed and healing":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.mov_speed_buff += 56
    eventPlayer.setMoveSpeed(min(max(100 + eventPlayer.mov_speed_buff, 20), 200))
    waitUntil(not eventPlayer.isUsingAbility1() or eventPlayer.isDead(), 99999)
    if eventPlayer.isDead():
        goto lbl_0
    eventPlayer.mov_speed_buff -= 56
    eventPlayer.setMoveSpeed(min(max(100 + eventPlayer.mov_speed_buff, 20), 200))
    lbl_0:
