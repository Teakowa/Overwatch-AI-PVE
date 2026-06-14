#!mainFile "../../main.opy"
#!optimizeStrict

rule "[wuyang/init.opy]: Detect switch to wuyang":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero wuyang

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[wuyang/init.opy]: Initialize wuyang":
    @Event eachPlayer
    @Hero wuyang
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["玩水摩西", "成都摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false
