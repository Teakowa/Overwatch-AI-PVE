#!mainFile "../../main.opy"
#!optimizeStrict

rule "[mercy/init.opy]: Detect switch to Mercy":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero mercy

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[mercy/init.opy]: Initialize Mercy":
    @Event eachPlayer
    @Hero mercy
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer.setMaxAmmo(0, 20)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["摩西", "拉使", "国服摩西请战", "我 有 恋 尸 癖", "慈 悲 十 三 摩", "食 尸 鬼"]))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.MERCY:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成治疗 +35%\r\n*快速治疗 提供25点额外治疗\r\n*女武神\r\n  受到伤害 -{1}%\r\n  持续期间重生无冷却时间\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), MercyBuff[0])
