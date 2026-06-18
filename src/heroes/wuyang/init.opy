#!mainFile "../../main.opy"
#!optimizeStrict

rule "[wuyang/init.opy]: Detect switch to wuyang":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero wuyang

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[wuyang/init.opy]: Initialize wuyang":
    @Event eachPlayer
    @Hero wuyang
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["玩水摩西", "成都摩西"]))
    lbl_0:
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*水珠爆炸附带目标最大生命值8%额外伤害\r\n 并使{1}CD-1秒\r\n{2} 飞流步 回复{3}生命值 减伤{4}%\r\n{1} 翻江浪 对同一目标命中2次后冻结{5}秒\r\n{6} 惊涛破 使友方回复满生命值\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), 4.5 * WuyangBuff[2], WuyangBuff[3], WUYANG_ABILITY2_FROZEN_DURATION, abilityIconString(eventPlayer.getHero(), Button.ULTIMATE))
    eventPlayer._reset_requested = false
