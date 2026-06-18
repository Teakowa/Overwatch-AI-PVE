#!mainFile "../../main.opy"
#!optimizeStrict

rule "[venture/init.opy]: Detect switch to venture":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero venture

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[venture/init.opy]: Initialize venture":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["钻地摩西", "丁真摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.VENTURE:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +40%\r\n*受到伤害 -30%\r\n钻地  \r\n  持续时间 +300%\r\n  移动速度 +156%\r\n钻头突刺 冷却时间 -25%\n\n※※离开重生室隐藏".format(eventPlayer.getHero())
