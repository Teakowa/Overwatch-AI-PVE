#!mainFile "../../main.opy"
#!optimizeStrict

rule "[reaper/init.opy]: Detect switch to Reaper":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero reaper

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[reaper/init.opy]: Initialize Reaper":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["滚筒洗衣机", "转圈摩西", "龙卷风摩西", "哈哈摩西", "菜就多练"]))
    lbl_0:
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.REAPER:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -35%\r\n*收割（被动）击杀获得灵魂层数\r\n灵魂层数会增强技能并缩短冷却\n\n※※离开重生室隐藏".format(eventPlayer.getHero())
