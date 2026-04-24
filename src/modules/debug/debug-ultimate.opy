#!optimizeStrict

rule "[Global][Debug]Auto Ultimate Gain":
    @Event eachPlayer
    @Condition Debug_UltimateGain != 0
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.getUltCharge() != 100
    @Disabled
    
    eventPlayer.setUltCharge(100)


