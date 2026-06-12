#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Moira]: Abilities to heal self":
    @Event eachPlayer
    @Hero moira
    @Condition any([eventPlayer.isUsingAbility1(), eventPlayer.getAbilityCooldown(Button.ABILITY_2) >= 7.5, eventPlayer.isUsingUltimate()]) == true
    @Condition eventPlayer.getNormalizedHealth() < 1

    heal(eventPlayer, eventPlayer, MoiraBuff[0] * (eventPlayer.getMaxHealth() - eventPlayer.getHealth()))
    wait(WAIT_SHORT_FRAME)
#!include "ultimate.opy"
