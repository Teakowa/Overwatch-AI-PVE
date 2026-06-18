#!mainFile "../../main.opy"
#!optimizeStrict


rule "[Sierra]: Detect switch to Sierra":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero sierra

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Sierra] Initialize":
    @Event eachPlayer
    @Hero sierra
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["拉西", "无人机摩西"]))
    lbl_0:
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -25%\r\n{1} 锚点无人机 每秒回复50生命值\r\n{2} 追踪弹 对命中目标的伤害提高{3}%\r\n  击杀后返还CD\r\n{4} 开路先锋 击倒敌人并造成额外伤害\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE), SierraBuff[1] - 100, abilityIconString(eventPlayer.getHero(), Button.ULTIMATE), SierraBuff[2])
    eventPlayer._reset_requested = false
