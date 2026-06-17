#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Domina/init.opy]: Detect switch to Domina":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero domina

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Domina/init.opy]: Initialize Domina":
    @Event eachPlayer
    @Hero domina
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.heroNum = BotHeroArray.index(eventPlayer.getHero())
    lbl_0:
    eventPlayer._reset_requested = false
