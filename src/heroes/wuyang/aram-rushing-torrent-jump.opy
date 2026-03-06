rule "[Wuyang]: Rushing Torrent jump":
    @Event eachPlayer
    @Hero wuyang
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    #@Condition eventPlayer.isInAir() != true

    eventPlayer.applyImpulse(Vector.UP, 12, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.16)
    waitUntil(eventPlayer.isOnGround(), 3)
