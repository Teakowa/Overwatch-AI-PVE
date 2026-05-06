#!optimizeStrict

rule "[Tracer] Recall Healing":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer.isUsingAbility2() == true

    heal(eventPlayer, null, 50)
