#!optimizeStrict

rule "[Emre/init.opy]: Detect switch to Emre":
    @Event eachPlayer
    @Hero emre

    eventPlayer.reset_pvar[0] = true

rule "[Emre/init.opy]: Initialize Emre":
    @Event eachPlayer
    @Hero emre
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    eventPlayer.reset_pvar[0] = false
