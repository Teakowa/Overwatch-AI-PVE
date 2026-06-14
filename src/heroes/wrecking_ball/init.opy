#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Wrecking Ball]: Detect switch to Wrecking Ball":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero wreckingBall

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Wrecking Ball] Initialize":
    @Event eachPlayer
    @Hero wreckingBall
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #removeTankPassive()
    eventPlayer._reset_requested = false
