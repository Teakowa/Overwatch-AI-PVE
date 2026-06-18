#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Ashe]: Detect switch to Ashe":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero ashe

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Ashe] Initialize":
    @Event eachPlayer
    @Hero ashe
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["张三的绯闻女友", "KAI了", "ANS", "Bob摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.ASHE:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*毒蛇\r\n  弹药增加至 15 发\r\n  暴击倍率提高至 ×{1}\r\n  完成击杀后恢复全部子弹\r\n*延时雷管\r\n  冷却时间降低至8秒\r\n*短筒猎枪\r\n  冷却时间降低至8秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), HeadshotDamage[1])
