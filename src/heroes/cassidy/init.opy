rule "[Cassidy]: Detect switch to Cassidy":

    @Event eachPlayer

    @Hero cassidy

    eventPlayer.reset_pvar[0] = true


rule "[Cassidy]: Initialize Cassidy":

    @Event eachPlayer

    @Hero cassidy

    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()

    if eventPlayer.getTeam() != Team.1:

        goto lbl_0

    eventPlayer.startForcingName(random.choice(["张三", "天王老子", "KAI了", "麦克雷", "六连摩西"]))

    lbl_0:

    eventPlayer.reset_pvar[0] = false
