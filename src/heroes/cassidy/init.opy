#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Cassidy]: Detect switch to Cassidy":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero cassidy

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Cassidy]: Initialize Cassidy":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["张三", "天王老子", "KAI了", "麦克雷", "六连摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false
