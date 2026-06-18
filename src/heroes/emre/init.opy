#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Emre/init.opy]: Detect switch to Emre":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero emre

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Emre/init.opy]: Initialize Emre":
    @Event eachPlayer
    @Hero emre
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["不是M", "天眼摩西", "丢雷摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false

