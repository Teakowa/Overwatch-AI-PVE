#!mainFile "../../main.opy"
#!optimizeStrict

rule "[JetpackCat/init.opy]: Detect switch to JetpackCat":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero jetpackCat

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[JetpackCat/init.opy]: Initialize JetpackCat":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.JETPACK_CAT:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -40%\r\n*造成治疗 +50%\r\n{1} 救生索 额外减伤35%\r\n{2} 呼噜噜 清除负面状态\r\n{3} 猫猫劫 额外减伤75%\r\n  对目标造成50%最大生命值伤害\r\n*近战造成0.6秒击晕\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2), abilityIconString(eventPlayer.getHero(), Button.ULTIMATE))
