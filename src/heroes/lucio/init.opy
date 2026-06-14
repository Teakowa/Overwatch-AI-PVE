#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Lucio]: Detect switch to Lucio":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero lucio

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Lucio] Initialize":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["巴西拳王", "喇叭摩西", "轮滑摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false
