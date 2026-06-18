#!mainFile "../../main.opy"
#!optimizeStrict

rule "[zenyatta]: Detect switch to zenyatta":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero zenyatta

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[zenyatta]: init":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer.setMaxAmmo(0, 20)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["武僧", "出家摩西", "机械摩西", "就这", "JJONAK"]))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.ZENYATTA:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +60%\r\n*弹道速度 +25%\r\n*暴击倍率提高至 ×{1}\r\n*蹬 将敌人击退并让禅雅塔向反方向弹开\r\n*圣 治疗量提高至400/s 移速+25%\r\n  无法被命中 免疫所有控制\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), 1 + HeadshotDamage[0])
