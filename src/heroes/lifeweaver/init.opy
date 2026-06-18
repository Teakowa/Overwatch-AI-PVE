#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Lifeweaver]: Detect switch to Lifeweaver":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero lifeweaver

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Lifeweaver] Initialize":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.LIFEWEAVER:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成治疗 +60%\r\n{1} 花瓣平台\r\n  冷却时间降低至 9 秒\r\n{2} 生命之握\r\n  冷却时间降低至约6.2秒\r\n  清除目标负面状态\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2))
