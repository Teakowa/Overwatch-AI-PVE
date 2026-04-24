#!optimizeStrict

rule "[wuyang/init.opy]: Detect switch to wuyang":
    @Event eachPlayer
    @Hero wuyang

    eventPlayer.reset_pvar[0] = true

rule "[wuyang/init.opy]: Initialize wuyang":
    @Event eachPlayer
    @Hero wuyang
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["玩水摩西", "成都摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false
