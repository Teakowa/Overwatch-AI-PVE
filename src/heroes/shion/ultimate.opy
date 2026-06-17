#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Shion]: Ultimate kill charge refund tracking":
    @Event eachPlayer
    @Hero shion
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.shion_ult_refund_armed != true

    eventPlayer.shion_ult_refund_armed = true
    waitUntil(not eventPlayer.isUsingUltimate() or eventPlayer.isDead() or eventPlayer._reset_requested != false, 30)
    eventPlayer.shion_ult_refund_armed = false

rule "[Shion]: Ultimate kill charge refund":
    @Event playerEarnedElimination
    @Hero shion
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.shion_ult_refund_armed == true
    @Condition eventPlayer.getUltCharge() < 100

    eventPlayer.setUltCharge(min(100, eventPlayer.getUltCharge() + ShionBuff[4]))
