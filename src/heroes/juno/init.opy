#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Juno]: Detect switch to Juno":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero juno

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Juno] Initialize":
    @Event eachPlayer
    @Hero juno
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.heroNum = BotHeroArray.index(eventPlayer.getHero())
    eventPlayer.startForcingName(random.choice(["轨投摩西", "香香糯糯", "火星摩西", "大头摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer._reset_requested = false
