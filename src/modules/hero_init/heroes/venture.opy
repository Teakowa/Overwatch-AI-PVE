rule "[venture/init.opy]: Detect switch to venture":
    @Event eachPlayer
    @Hero venture
    
    eventPlayer.reset_pvar[0] = true


rule "[venture/init.opy]: Initialize venture":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["钻地摩西", "丁真摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


