#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Junker Queen]: Detect switch to Junker Queen":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero junkerQueen

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Junker Queen] Initialize":
    @Event eachPlayer
    @Hero junkerQueen
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer.setHealingDealt(144.46 if eventPlayer.getTeam() == Team.1 else 122.23)
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["姐就是女王 自信放光芒", "你若爱就来 不爱莫张狂", "收起你的那些小小花花肠", "甜言或蜜语去哄小姑娘", "姐就是女王 自信放光芒", "有钱了不起 姐也很自强", "不惧风霜雪雨逆风也飞翔", "活成一束光世界都照亮"]))
    lbl_0:
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.JUNKER_QUEEN:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +30%\r\n*受到伤害 -40%\r\n*血斩 冷却时间降低至 6 秒\r\n*锯齿利刃 冷却时间降低至 4 秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero())
