rule "[Vendetta/init.opy]: Detect switch to Vendetta":
    @Event eachPlayer
    @Hero vendetta
    
    eventPlayer.reset_pvar[0] = true


rule "[Vendetta/init.opy]: Initialize Vendetta":
    @Event eachPlayer
    @Hero vendetta
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["大剑摩西", "一刀摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


