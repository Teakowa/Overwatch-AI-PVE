#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Mizuki/init.opy]: Detect switch to Mizuki":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero mizuki

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Mizuki/init.opy]: Initialize Mizuki":
    @Event eachPlayer
    @Hero mizuki
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer._reset_requested = false
