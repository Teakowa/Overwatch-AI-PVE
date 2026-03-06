rule "[Zenyatta] remove Snap Kick hp":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.heart_steel[1] != 0
    
    wait(5)
    removeHealthPool(eventPlayer.heart_steel[0])
    eventPlayer.heart_steel[1] = 0
    eventPlayer.heart_steel[0] = 0
    wait(0.16)
    if ruleCondition:
        loop()
