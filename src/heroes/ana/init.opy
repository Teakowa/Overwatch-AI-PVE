#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Ana]: Detect switch to Ana":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero ana

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Ana] Initialize":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["老年摩西", "睡觉摩西", "末日铁娜", "独眼摩西"]))
    eventPlayer.heroNum = BotHeroArray.index(eventPlayer.getHero())
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.ANA:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +15%\r\n*造成治疗 +22%\r\n*生物手雷\r\n  使敌方燃烧 每秒造成{1}%最大生命值伤害\r\n*麻醉镖\r\n  冷却时间降低至10秒\r\n*纳米激素\r\n  治疗目标全部已损失生命值\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), Ana_GrenadeDamage)
