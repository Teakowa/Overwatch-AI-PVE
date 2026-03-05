rule "[Venture] Burrow speed and healing":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer.isUsingAbility1() == true
    
    if abs(eventPlayer.mov_speed_buff) < abs(56):
        eventPlayer.mov_speed_buff = 56
        applySignedMoveSpeed()
    waitUntil(not eventPlayer.isUsingAbility1() or eventPlayer.isDead(), 99999)
    if eventPlayer.isDead():
        goto lbl_0
    if eventPlayer.mov_speed_buff == 56:
        eventPlayer.mov_speed_buff = 0
        applySignedMoveSpeed()
    lbl_0:
