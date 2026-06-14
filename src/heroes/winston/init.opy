#!mainFile "../../main.opy"
#!optimizeStrict

rule "[winston/init.opy]: Detect switch to Winston":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero winston

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[winston/init.opy]: Initialize Winston":
    @Event eachPlayer
    @Hero winston
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["电音王子吴亦凡", "雷电法王杨永信", "电击摩西", "菜就多练"]))
    lbl_0:
    eventPlayer._reset_requested = false
