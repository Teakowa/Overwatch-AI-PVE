rule "[Hazard/init.opy]: Detect switch to Hazard":
    @Event eachPlayer
    @Hero hazard

    eventPlayer.reset_pvar[0] = true

rule "[Hazard/init.opy]: Initialize Hazard":
    @Event eachPlayer
    @Hero hazard
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    #removeTankPassive()
    eventPlayer.reset_pvar[0] = false
