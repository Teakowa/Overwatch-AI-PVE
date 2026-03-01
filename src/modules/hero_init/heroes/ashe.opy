rule "[Ashe]: Detect switch to Ashe":
    @Event eachPlayer
    @Hero ashe
    
    eventPlayer.reset_pvar[0] = true


rule "[Ashe] Initialize":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 200
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["张三的绯闻女友", "KAI了", "ANS", "Bob摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


