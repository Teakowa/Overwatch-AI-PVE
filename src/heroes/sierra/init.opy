#!mainFile "../../main.opy"
#!optimizeStrict


rule "[Sierra]: Detect switch to Sierra":
    @Event eachPlayer
    @Hero sierra

    eventPlayer.reset_pvar[0] = true

rule "[Sierra] Initialize":
    @Event eachPlayer
    @Hero sierra
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["拉西", "无人机摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false
