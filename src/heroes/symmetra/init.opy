#!mainFile "../../main.opy"
#!optimizeStrict

rule "[symmetra/init.opy]: Detect switch to Symmetra":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero symmetra

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[symmetra/init.opy]: Initialize Symmetra":
    @Event eachPlayer
    @Hero symmetra
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["性♂感荷官在线烫头", "绿洲城首家赌场", "麻豆传媒摄影师", "烫头摩西"]))
    lbl_0:
    getPlayers(eventPlayer.getTeam()).reset_pvar[3] = eventPlayer
    eventPlayer._reset_requested = false
