#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Juno]: Detect switch to Juno":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero juno

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Juno] Initialize":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["轨投摩西", "香香糯糯", "火星摩西", "大头摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.JUNO:
            eventPlayer.changelog_body = "\r\n{0}\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format("●{0}\r\n*造成治疗 +45%".format(eventPlayer.getHero()), "{0} 超能环域 冷却时间降低至12秒".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_1)), "{0}\r\n{1}".format("{0} 脉冲星飞雷 冷却时间降低至8秒".format(abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE)), "{0} 轨道射线 范围内所有友方受到伤害-{1}%（唯一特效）".format(abilityIconString(eventPlayer.getHero(), Button.ULTIMATE), JunoBuff)))
