#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Emre/init.opy]: Detect switch to Emre":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero emre

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Emre/init.opy]: Initialize Emre":
    @Event eachPlayer
    @Hero emre
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["不是M", "天眼摩西", "丢雷摩西"]))
    lbl_0:
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -10%\r\n{1} 赛博手雷 额外造成50点伤害，使其燃烧{3}秒\r\n{2} 虹吸冲击枪 冷却时间降低至8秒\r\n  \r\n*覆盖协议：使命中的敌人燃烧 造成75+{4}%最大生命值额外伤害\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), EmreBuff[0], EmreBuff[1])
    eventPlayer._reset_requested = false
