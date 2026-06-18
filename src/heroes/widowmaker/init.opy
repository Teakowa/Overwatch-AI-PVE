#!mainFile "../../main.opy"
#!optimizeStrict

rule "[widowmaker/init.opy]: Detect switch to Widowmaker":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero widowmaker

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[widowmaker/init.opy]: Initialize Widowmaker":
    @Event eachPlayer
    @Hero widowmaker
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer.setMaxAmmo(0, 25)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["ANS", "亿枪一个", "KAI了就是KAI了？", "女兵摩西", "MN3"]))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer._reset_requested = false

