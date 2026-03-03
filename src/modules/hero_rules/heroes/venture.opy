rule "[Venture] Burrow speed and healing":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer.isUsingAbility1() == true
    
    applyMoveSpeedOverride(56)
    waitUntil(not eventPlayer.isUsingAbility1() or eventPlayer.isDead(), 99999)
    if eventPlayer.isDead():
        goto lbl_0
    clearMoveSpeedOverride(56)
    lbl_0:
