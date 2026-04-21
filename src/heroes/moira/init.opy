rule "[Moira]: Detect switch to Moira":

    @Event eachPlayer

    @Hero moira

    eventPlayer.reset_pvar[0] = true


rule "[Moira] Initialize":

    @Event eachPlayer

    @Hero moira

    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()

    if eventPlayer.getTeam() != Team.1:

        goto lbl_0

    eventPlayer.startForcingName(random.choice(["五  金  上  将", "五金上将莫伊拉", "五金摩西", "生化摩西"]))

    lbl_0:

    eventPlayer.reset_pvar[0] = false
