#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Hazard/init.opy]: Detect switch to Hazard":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero hazard

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Hazard/init.opy]: Initialize Hazard":
    @Event eachPlayer
    @Hero hazard
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #removeTankPassive()
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.HAZARD:
            eventPlayer.changelog_body = "\r\n{0}\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format("●{0}\r\n*造成伤害 +25%\r\n*受到伤害 -45%".format(eventPlayer.getHero()), "*尖刺护体 基于受到伤害造成额外伤害\r\n  在格挡期间获得{0}%终极技能充能和生命回复".format(HazardBuff[1]), "{0}".format("*千针雨 不再根据伤害获得能量"))
