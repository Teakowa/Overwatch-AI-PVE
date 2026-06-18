#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Kiriko]: Detect switch to Kiriko":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero kiriko

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Kiriko] Initialize":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["忍者摩西", "纸钱摩西", "破 摩 十 三 雾"]))
    lbl_0:
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.KIRIKO:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*造成治疗 +35%\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), "暴击倍率提高至 ×{0}".format(HeadshotDamage[2] + 1), "{0} 瞬 最远距离提高至约85米\r\n{1} 铃 冷却时间降低至 8 秒\r\n  无敌时间提高至 1.8 秒".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2)))
