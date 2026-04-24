#!optimizeStrict

rule "[Mauga]: Cage Fight ignore headshot":
    @Event eachPlayer
    @Team 1
    @Hero mauga
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.startHealingOverTime(eventPlayer, 50, 15)
