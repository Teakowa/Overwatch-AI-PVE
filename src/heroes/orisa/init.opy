#!optimizeStrict

rule "[Orisa]: Detect switch to Orisa":
    @Event eachPlayer
    @Hero orisa

    eventPlayer.reset_pvar[0] = true

rule "[Orisa] Initialize":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["命运羊驼", "美羊羊", "唯一真神", "标枪摩西", "小米Su7 Ultra"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false
