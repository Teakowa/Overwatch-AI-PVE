#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Moira]: Detect switch to Moira":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero moira

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Moira] Initialize":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["五  金  上  将", "五金上将莫伊拉", "五金摩西", "生化摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false

