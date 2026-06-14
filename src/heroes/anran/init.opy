#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Anran/init.opy]: Detect switch to Anran":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero anran

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Anran/init.opy]: Initialize Anran":
    @Event eachPlayer
    @Hero anran
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["扇风摩西", "加热摩西", "AAA成都烤肉总代", "别来无漾"]))
    eventPlayer.heroNum = BotHeroArray.index(eventPlayer.getHero())
    lbl_0:
    eventPlayer._reset_requested = false
