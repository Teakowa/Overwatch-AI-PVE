#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Shion]: Execution kill window":
    @Event playerDealtDamage
    @Hero shion
    @Condition eventPlayer.isAlive() == true
    @Condition eventAbility == Button.SECONDARY_FIRE

    eventPlayer.shion_execution_kill_window = true
    wait(0.6)
    eventPlayer.shion_execution_kill_window = false

rule "[Shion]: Execution kill reset cooldown":
    @Event playerEarnedElimination
    @Hero shion
    @Condition ShionBuff[3] == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.shion_execution_kill_window == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
