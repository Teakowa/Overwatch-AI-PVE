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

