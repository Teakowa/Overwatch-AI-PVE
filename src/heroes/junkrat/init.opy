#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Junkrat]: Detect switch to Junkrat":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero junkrat

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Junkrat] Initialize":
    @Event eachPlayer
    @Hero junkrat
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["拉 史 大 王", "拉 史 摩 西", "鼠鼠摩西", "鸭脖摩西", "夹子摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false

