#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Mauga]: Cage Fight ignore headshot":
    @Event eachPlayer
    @Team 1
    @Hero mauga
    @Condition eventPlayer.isUsingUltimate() == true

    heal(eventPlayer, eventPlayer, MAUGA_ULTIMATE_HEAL)
