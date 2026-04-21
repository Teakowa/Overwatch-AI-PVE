rule "[Moira]: Abilities to heal self":
    @Event eachPlayer
    @Hero moira
    @Condition any([eventPlayer.isUsingAbility1(), eventPlayer.getAbilityCooldown(Button.ABILITY_2) >= 7.5, eventPlayer.isUsingUltimate()]) == true
    @Condition eventPlayer.getNormalizedHealth() < 1

    eventPlayer.startHealingOverTime(eventPlayer, 0.6, 0.75 * (eventPlayer.getMaxHealth() - eventPlayer.getHealth()))
    wait(WAIT_SHORT_FRAME)
#!include "ultimate.opy"
