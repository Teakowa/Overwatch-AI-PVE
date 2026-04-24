#!optimizeStrict

rule "[Sombra]: Detect switch to Sombra":
    @Event eachPlayer
    @Hero sombra

    eventPlayer.reset_pvar[0] = true

rule "[Sombra] Initialize":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["全民偶像酸不辣", "多少有点LIP", "阳光开朗小女孩", "隐身摩西"]))
    lbl_0:
    getPlayers(eventPlayer.getTeam()).reset_pvar[4] = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).reset_pvar[7] = eventPlayer
    eventPlayer.reset_pvar[0] = false
