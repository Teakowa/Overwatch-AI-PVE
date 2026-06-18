#!mainFile "../../main.opy"
#!optimizeStrict

rule "[venture/init.opy]: Detect switch to venture":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero venture

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[venture/init.opy]: Initialize venture":
    @Event eachPlayer
    @Hero venture
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["钻地摩西", "丁真摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false

