#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Mei]: Detect switch to Mei":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero mei

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Mei] Initialize":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["识得唔识得啊", "冰雕摩西", "麦克美", "周美玲冰雪大世界", "哈尔滨摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.MEI:
            eventPlayer.changelog_body = "\r\n●{0}\r\n{1} 冰墙\r\n  冷却时间降低至约6.7秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1))
