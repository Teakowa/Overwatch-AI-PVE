#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Baptiste]: Detect switch to Baptiste":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero baptiste

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Baptiste] Initialize":
    @Event eachPlayer
    @Hero baptiste
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer.setMaxAmmo(0, 45)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
    eventPlayer.setMaxAmmo(1, 25)
    eventPlayer.setAmmo(1, eventPlayer.getMaxAmmo(1))
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["大 76", "Kai了", "天使", "飞饼摩西", "锁头摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +50%\r\n*暴击额外伤害 +{1}\r\n*维生力场\r\n  冷却时间降低至约10.5秒\r\n*增幅矩阵\r\n  持续时间提高至 15 秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), BaptisteBuff[0])
    eventPlayer._reset_requested = false
