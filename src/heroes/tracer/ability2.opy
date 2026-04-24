#!optimizeStrict

rule "[Tracer] Recall Healing":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer.isUsingAbility2() == true

    eventPlayer.startHealingOverTime(null, 2, 25)
