#!optimizeStrict

rule "[Wuyang]: Tidal Blast Allies Target":
    @Event playerDealtHealing
    @Hero wuyang
    @Condition eventAbility == Button.ULTIMATE

    heal(eventPlayer, healee, eventPlayer.getMaxHealth())

