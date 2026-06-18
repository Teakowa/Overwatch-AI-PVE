#!mainFile "../../main.opy"
#!optimizeStrict

rule "[tracer/init.opy]: Detect switch to Tracer":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero tracer

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[tracer/init.opy]: Initialize Tracer":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 8)
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["跳跳熊", "FLETA", "EVAEL", "炸弹摩西", "瞬移摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.TRACER:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +60%\r\n*受到伤害 -65%\r\n*回溯 立刻回复50生命值\r\n  回溯期间完成击杀时回满闪现并重置回溯冷却\r\n*重生 阵亡后立刻重生\r\n*脉冲炸弹 充能速度 +60%\n\n※※离开重生室隐藏".format(eventPlayer.getHero())
