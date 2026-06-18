#!mainFile "../../main.opy"
#!optimizeStrict

rule "[winston/init.opy]: Detect switch to Winston":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero winston

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[winston/init.opy]: Initialize Winston":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["电音王子吴亦凡", "雷电法王杨永信", "电击摩西", "菜就多练"]))
    lbl_0:
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.WINSTON:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*受到伤害 -35%\r\n*造成伤害 +10%\r\n{1} 特斯拉炮-集束电击\r\n  回复已造成伤害的生命值并额外造成目标最大生命值{2}%伤害\r\n{3} 屏障发射器\r\n  冷却时间降低至12秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE), WinstonBuff[0], abilityIconString(eventPlayer.getHero(), Button.ABILITY_2))
