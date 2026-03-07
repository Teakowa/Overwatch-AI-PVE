rule "[Wuyang]: Tidal Blast Allies Target":
    @Event playerDealtHealing
    @Hero wuyang
    @Condition eventAbility == Button.ULTIMATE

    eventPlayer.startHealingOverTime(healee, 1.25, eventPlayer.getMaxHealth() * 0.5 / 1.25)
