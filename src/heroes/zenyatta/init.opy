rule "[zenyatta]: Detect switch to zenyatta":

    @Event eachPlayer

    @Hero zenyatta

    eventPlayer.reset_pvar[0] = true


rule "[zenyatta]: init":

    @Event eachPlayer

    @Hero zenyatta

    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()

    eventPlayer.setMaxAmmo(0, 20)

    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())

    if eventPlayer.getTeam() != Team.1:

        goto lbl_0

    eventPlayer.startForcingName(random.choice(["武僧", "出家摩西", "机械摩西", "就这", "JJONAK"]))

    lbl_0:

    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer

    eventPlayer.reset_pvar[0] = false
