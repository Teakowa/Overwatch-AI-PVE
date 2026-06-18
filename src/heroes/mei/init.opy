#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Mei]: Detect switch to Mei":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero mei

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Mei] Initialize":
    @Event eachPlayer
    @Hero mei
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["识得唔识得啊", "冰雕摩西", "麦克美", "周美玲冰雪大世界", "哈尔滨摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false

