#!mainFile "../../main.opy"

rule "[Sierra]: Detect switch to Sierra":
    @Event eachPlayer
    @Hero sierra

    eventPlayer.reset_pvar[0] = true

rule "[Sierra] Initialize":
    @Event eachPlayer
    @Hero sierra
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    # #removeTankPassive()
    # if eventPlayer.getTeam() != Team.1:
    #     goto lbl_0
    # eventPlayer.startForcingName(random.choice(["核桃摩西", "长 者", "大爷摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false
