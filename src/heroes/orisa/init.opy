#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Orisa]: Detect switch to Orisa":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero orisa

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Orisa] Initialize":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["命运羊驼", "美羊羊", "唯一真神", "标枪摩西", "小米Su7 Ultra"]))
    lbl_0:
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.ORISA:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*受到伤害 -45%\r\n*强固防御\r\n 冷却时间降低至约2秒\r\n 获得额外临时护甲\r\n 反弹{1}%受到的伤害\r\n*标枪旋击\r\n 冷却时间增加至约9.4秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), Orisa_Fortify[1])
