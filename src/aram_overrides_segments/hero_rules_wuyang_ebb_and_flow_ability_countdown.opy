rule "[Wuyang]: Ebb and Flow Ability":
    @Event eachPlayer
    @Condition eventPlayer.wuyang_buff[2] >= 2
    
    eventPlayer.setStatusEffect(eventPlayer.reset_pvar[14], Status.FROZEN, 2.5)
    waitUntil(eventPlayer.unaffected or eventPlayer.hasStatus(Status.INVINCIBLE) or eventPlayer.hasStatus(Status.PHASED_OUT), 5)
    eventPlayer.wuyang_buff[2] *= 0

rule "[Wuyang]: Ebb and Flow countdown":
    @Event eachPlayer
    @Condition eventPlayer.wuyang_buff[2] > 0
    
    wait(2.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.wuyang_buff[2]--
    if ruleCondition:
        loop()
    #wait(0.25, Wait.RESTART_WHEN_TRUE)

