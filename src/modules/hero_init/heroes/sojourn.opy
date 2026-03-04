rule "[Sojourn]: Detect switch to Sojourn":
    @Event eachPlayer
    @Hero sojourn
    
    eventPlayer.reset_pvar[0] = true


rule "[Sojourn] Initialize":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["跳跳熊", "我超摩西", "我超", "ANS", "MN3", "EVAEL", "没KAI"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


