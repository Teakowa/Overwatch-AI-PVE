rule "[Wuyang]: Rushing Torrent":
    @Event eachPlayer
    @Hero wuyang
    @Condition eventPlayer.isUsingAbility1() == true

    if eventPlayer.getNormalizedHealth() == 1:
        goto lbl_0
    eventPlayer.startHealingOverTime(eventPlayer, 4.5, WuyangBuff[2])
    eventPlayer.wuyang_buff[0] = getLastHealingOverTimeId()
    lbl_0:
    eventPlayer.dmg_reduction = WuyangBuff[3]
    eventPlayer.setDamageReceived(100 - eventPlayer.dmg_reduction)
    waitUntil(not eventPlayer.isUsingAbility1(), 4.5)
    eventPlayer.dmg_reduction = 0
    stopHealingOverTime(eventPlayer.wuyang_buff[0])
    eventPlayer.setDamageReceived(100)

rule "[Wuyang]: Rushing Torrent jump":
    @Event eachPlayer
    @Hero wuyang
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    #@Condition eventPlayer.isInAir() != true
    @Disabled

    eventPlayer.applyImpulse(Vector.UP, 12, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(WAIT_SHORT_FRAME)
    waitUntil(eventPlayer.isOnGround(), 3)
