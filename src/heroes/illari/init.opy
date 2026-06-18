#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Illari]: Detect switch to Illari":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero illari

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Illari] Initialize":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.ILLARI:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +60%\r\n*受到伤害 +5%\r\n*能量回复速度 +25%\r\n*治疗光塔 冷却时间降低50%\r\n*桎梏灼日\r\n  基于附近友军数量造成额外最大生命值伤害\n\n※※离开重生室隐藏".format(eventPlayer.getHero())
