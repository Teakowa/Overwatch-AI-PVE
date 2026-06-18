#!mainFile "../../main.opy"
#!optimizeStrict

rule "[bastion/init.opy]: Detect switch to Bastion":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero bastion

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[bastion/init.opy]: Initialize Bastion":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["电脑", "嘟嘟嘟嘟嘟", "大炮摩西", "无可奉告"]))
    lbl_0:
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.BASTION:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +25%\r\n*受到伤害 -30%\r\n{1} 强攻模式\r\n  移动速度 +200%\r\n{2} A-36战术榴弹\r\n  冷却时间降低至6秒\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE))
