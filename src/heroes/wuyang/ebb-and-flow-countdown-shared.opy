rule "[Wuyang]: Ebb and Flow countdown":
    @Event eachPlayer
    @Condition eventPlayer.wuyang_buff[2] > 0

    wait(2.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.wuyang_buff[2]--
    if ruleCondition:
        loop()
    #wait(0.25, Wait.RESTART_WHEN_TRUE)
