#!mainFile "../../main.opy"
#!optimizeStrict

rule "[hanzo/init.opy]: Detect switch to Hanzo":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero hanzo

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[hanzo/init.opy]: Initialize Hanzo":
    @Event eachPlayer
    @Hero hanzo
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["ANS", "吃矢不忘拉矢人", "拉矢摩西", "贩箭摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false

