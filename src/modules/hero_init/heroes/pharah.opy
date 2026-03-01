rule "[pharah/init.opy]: Detect switch to Pharah":
    @Event eachPlayer
    @Hero pharah
    
    eventPlayer.reset_pvar[0] = true


rule "[pharah/init.opy]: Initialize Pharah":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.custom_hp_pvar[0] = 100
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 125
    #applyCustomHp()
    lbl_0:
    eventPlayer.reset_pvar[0] = false


