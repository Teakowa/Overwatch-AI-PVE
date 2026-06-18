#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Anran/init.opy]: Detect switch to Anran":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero anran

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Anran/init.opy]: Initialize Anran":
    @Event eachPlayer
    @Hero anran
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["扇风摩西", "加热摩西", "AAA成都烤肉总代", "别来无漾"]))
    eventPlayer.heroNum = BotHeroArray.index(eventPlayer.getHero())
    lbl_0:
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.ANRAN:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -30%\r\n*怒炎冲 冷却时间降低至6秒\r\n*熠闪舞 冷却时间降低至6秒\r\n*烈焰 对所有燃烧中的敌人伤害提高25%（开始伤害调整）\n\n※※离开重生室隐藏".format(eventPlayer.getHero())
