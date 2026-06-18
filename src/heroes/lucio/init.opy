#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Lucio]: Detect switch to Lucio":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero lucio

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Lucio] Initialize":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["巴西拳王", "喇叭摩西", "轮滑摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.LUCIO:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +20%\r\n*造成治疗 +30%\r\n*受到伤害 -30%\r\n*音波命中时为附近友军回复{1}生命值\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), LucioBuff[0])
