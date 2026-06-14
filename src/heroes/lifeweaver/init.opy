#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Lifeweaver]: Detect switch to Lifeweaver":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero lifeweaver

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Lifeweaver] Initialize":
    @Event eachPlayer
    @Hero lifeweaver
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer._reset_requested = false
