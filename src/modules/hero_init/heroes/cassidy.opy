rule "[Cassidy]: Detect switch to Cassidy":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.reset_pvar[10] != eventPlayer.getHero()

    eventPlayer.reset_pvar[10] = eventPlayer.getHero()
    eventPlayer.reset_pvar[0] = true


rule "[Cassidy]: Initialize Cassidy":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 225
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["张三", "天王老子", "KAI了", "麦克雷", "六连摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


