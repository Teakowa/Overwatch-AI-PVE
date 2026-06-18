#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Kiriko]: Detect switch to Kiriko":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero kiriko

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Kiriko] Initialize":
    @Event eachPlayer
    @Hero kiriko
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["忍者摩西", "纸钱摩西", "破 摩 十 三 雾"]))
    lbl_0:
    eventPlayer._reset_requested = false

