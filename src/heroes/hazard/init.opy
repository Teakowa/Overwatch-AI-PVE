#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Hazard/init.opy]: Detect switch to Hazard":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero hazard

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Hazard/init.opy]: Initialize Hazard":
    @Event eachPlayer
    @Hero hazard
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.heroNum = BotHeroArray.index(eventPlayer.getHero())
    lbl_0:
    eventPlayer._reset_requested = false
