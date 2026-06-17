#!mainFile "../../main.opy"
#!optimizeStrict

rule "[pharah/init.opy]: Detect switch to Pharah":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero pharah

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[pharah/init.opy]: Initialize Pharah":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.heroNum = BotHeroArray.index(eventPlayer.getHero())
    lbl_0:
    eventPlayer._reset_requested = false
