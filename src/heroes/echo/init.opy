#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Echo]: Detect switch to Echo":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero echo

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Echo] Initialize":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.ECHO:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -30%\r\n*聚焦光束 持续期间伤害提高{1}%\r\n*人格复制期间终极充能最低保留{2}%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), EchoBuff[0], EchoBuff[1])
