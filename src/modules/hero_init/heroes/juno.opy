rule "[Juno]: Detect switch to Juno":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer.reset_pvar[10] != eventPlayer.getHero()

    eventPlayer.reset_pvar[10] = eventPlayer.getHero()
    eventPlayer.reset_pvar[0] = true


rule "[Juno] Initialize":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 50
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 175
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["轨投", "香香糯糯", "火星摩西", "大头摩西"]))
    lbl_0:
    #applyCustomHp()
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer.reset_pvar[0] = false


