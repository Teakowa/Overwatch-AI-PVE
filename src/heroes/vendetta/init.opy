#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Vendetta/init.opy]: Detect switch to Vendetta":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero vendetta

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Vendetta/init.opy]: Initialize Vendetta":
    @Event eachPlayer
    @Hero vendetta
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["大剑摩西", "一刀摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false
