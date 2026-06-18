#!mainFile "../../main.opy"
#!optimizeStrict

rule "[reinhardt/init.opy]: Detect switch to Reinhardt":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero reinhardt

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[reinhardt/init.opy]: Initialize Reinhardt":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #eventPlayer.setKnockbackReceived(REINHARDT_INIT_KNOCKBACK_RECEIVED)
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["小米Su7 Ultra", "Hadi", "冲锋摩西", "抡锤摩西"]))
    lbl_0:
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +5%\r\n*受到伤害 -25%\r\n*冲锋 根据剩余持续时间返还最多3秒cd\r\n*烈焰打击 恢复100%已造成伤害的生命值\r\n*裂地猛击 造成击杀返还100%充能\n\n※※离开重生室隐藏".format(eventPlayer.getHero())
    eventPlayer._reset_requested = false
