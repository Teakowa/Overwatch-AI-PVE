#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Zarya]: Detect switch to Zarya":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero zarya

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Zarya] Initialize":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer.zarya_buff[0] = true
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["Sinatraa", "泡泡摩西", "东北雨姐"]))
    lbl_0:
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.ZARYA:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -25%\r\n*胜利意志\r\n  生命值低于30%时触发\r\n  获得1秒无敌并重置屏障冷却\r\n  回复{1}生命值\r\n{2} 粒子屏障\r\n  冷却时间降低至约9秒\r\n{3} 投射屏障\r\n  为目标提供3秒50点临时生命值\r\n*重力喷涌\r\n  充能速度提高8%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), ZaryaBuff[1] * ZaryaBuff[2], abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2))
