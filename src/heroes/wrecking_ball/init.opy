#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Wrecking Ball]: Detect switch to Wrecking Ball":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero wreckingBall

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Wrecking Ball] Initialize":
    @Event eachPlayer
    @Hero wreckingBall
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #removeTankPassive()
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.WRECKING_BALL:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -15%\r\n*工程抓钩\r\n  冷却时间降低至4秒\r\n  在重生室中无冷却时间\r\n*感应护盾 冷却时间降低至12秒\r\n*重力坠击 冷却时间降低至6秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero())
