#!mainFile "../../main.opy"
#!optimizeStrict


rule "[Sierra]: Detect switch to Sierra":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero sierra

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Sierra] Initialize":
    @Event eachPlayer
    @Hero sierra
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["拉西", "无人机摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false

