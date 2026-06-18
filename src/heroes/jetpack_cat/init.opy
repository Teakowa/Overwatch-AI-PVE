#!mainFile "../../main.opy"
#!optimizeStrict

rule "[JetpackCat/init.opy]: Detect switch to JetpackCat":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero jetpackCat

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[JetpackCat/init.opy]: Initialize JetpackCat":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer._reset_requested = false

