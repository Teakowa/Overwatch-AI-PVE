rule "[Kiriko]: Detect switch to Kiriko":
    @Event eachPlayer
    @Hero kiriko
    
    eventPlayer.reset_pvar[0] = true


rule "[Kiriko] Initialize":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 225
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["忍者摩西", "纸钱摩西", "破 摩 十 三 雾"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


