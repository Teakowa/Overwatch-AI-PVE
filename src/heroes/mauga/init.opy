#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Mauga]: Detect switch to Mauga":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero mauga

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Mauga] Initialize":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["黑皮体育生", "黑皮摩西", "SSVGG", "Seiseiguigeigei", "发烧摩西", "小米SU7"]))
    lbl_0:
    eventPlayer._reset_requested = false

