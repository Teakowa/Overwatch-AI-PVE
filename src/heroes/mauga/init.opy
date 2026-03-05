rule "[Mauga]: Detect switch to Mauga":
    @Event eachPlayer
    @Hero mauga
    
    eventPlayer.reset_pvar[0] = true


rule "[Mauga] Initialize":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["黑皮体育生", "黑皮摩西", "SSVGG", "Seiseiguigeigei", "发烧摩西", "小米SU7"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


