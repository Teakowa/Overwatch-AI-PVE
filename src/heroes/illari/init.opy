#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Illari]: Detect switch to Illari":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero illari

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Illari] Initialize":
    @Event eachPlayer
    @Hero illari
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer._reset_requested = false

