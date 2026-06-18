#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Mizuki/init.opy]: Detect switch to Mizuki":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero mizuki

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Mizuki/init.opy]: Initialize Mizuki":
    @Event eachPlayer
    @Hero mizuki
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害+35%\r\n*受到伤害 -20%\r\n{1} 疗魂斗笠 额外治疗队友10%最大生命值 返还0.5秒cd\r\n{2} 替魂纸人 清除负面状态\r\n{3} 缚魂锁链 使敌人虚弱\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2))
    eventPlayer._reset_requested = false
