#!mainFile "../../main.opy"
#!optimizeStrict

rule "[hanzo/init.opy]: Detect switch to Hanzo":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero hanzo

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[hanzo/init.opy]: Initialize Hanzo":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["ANS", "吃矢不忘拉矢人", "拉矢摩西", "贩箭摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.HANZO:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +25%\r\n*弹道速度+35%\r\n*暴击额外伤害 +{1}\r\n*岚 冷却时间降低至7秒\r\n*音 冷却时间降低至9秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), HanzoBuff[0])
