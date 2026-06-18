#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Sojourn]: Detect switch to Sojourn":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero sojourn

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Sojourn] Initialize":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["跳跳熊", "我超摩西", "我超", "ANS", "MN3", "EVAEL", "没KAI"]))
    lbl_0:
    eventPlayer._reset_requested = false

