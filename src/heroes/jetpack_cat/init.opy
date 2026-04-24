#!optimizeStrict

rule "[JetpackCat/init.opy]: Detect switch to JetpackCat":
    @Event eachPlayer
    @Hero jetpackCat

    eventPlayer.reset_pvar[0] = true

rule "[JetpackCat/init.opy]: Initialize JetpackCat":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    eventPlayer.reset_pvar[0] = false
