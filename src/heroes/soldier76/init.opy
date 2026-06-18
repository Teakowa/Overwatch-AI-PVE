#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Soldier: 76]: Detect switch to Soldier 76":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero soldier

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Soldier: 76]: Initialize":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["国服顶尖小巴蒂", "跑男摩西", "奶棒摩西", "Kai了", "飞弹摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.SOLDIER:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +30%\r\n{1} 生物力场\r\n  冷却时间降低\r\n{2} 螺旋飞弹 使敌人燃烧并额外造成{4}点伤害\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE), S76Buff[0], S76Buff[1])
