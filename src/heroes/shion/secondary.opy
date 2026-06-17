#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Shion]: Execution kill reset cooldown":
    @Event playerEarnedElimination
    @Hero shion
    @Condition ShionBuff[3] == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
