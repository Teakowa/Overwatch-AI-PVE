#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Echo]: Detect switch to Echo":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero echo

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Echo] Initialize":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer._reset_requested = false

