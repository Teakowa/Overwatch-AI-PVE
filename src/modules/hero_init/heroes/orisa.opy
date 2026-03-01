rule "[Orisa]: Detect switch to Orisa":
    @Event eachPlayer
    @Hero orisa
    
    eventPlayer.reset_pvar[0] = true


rule "[Orisa] Initialize":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 250
    eventPlayer.custom_hp_pvar[1] = 200
    eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["命运羊驼", "美羊羊", "唯一真神", "标枪摩西", "小米Su7 Ultra"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


