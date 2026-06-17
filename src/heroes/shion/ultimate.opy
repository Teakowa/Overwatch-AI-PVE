#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Shion]: Ultimate kill charge refund":
    @Event playerEarnedElimination
    @Hero shion
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.getUltCharge() < 100

    eventPlayer.setUltCharge(min(100, eventPlayer.getUltCharge() + ShionBuff[4]))
