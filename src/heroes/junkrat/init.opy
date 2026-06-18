#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Junkrat]: Detect switch to Junkrat":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero junkrat

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Junkrat] Initialize":
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["拉 史 大 王", "拉 史 摩 西", "鼠鼠摩西", "鸭脖摩西", "夹子摩西"]))
    lbl_0:
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 -5%\r\n*受到伤害 +30%\r\n*所有击退效果-50%\r\n*攻击点燃敌人并额外造成5%当前生命值伤害\r\n{2} 炸弹轮胎\r\n  充能速度降低30%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.ULTIMATE))
    eventPlayer._reset_requested = false
