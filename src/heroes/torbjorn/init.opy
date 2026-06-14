#!mainFile "../../main.opy"
#!optimizeStrict

rule "[torbjorn/init.opy]: Detect switch to Torbjorn":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero torbjorn

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[torbjorn/init.opy]: Initialize Torbjorn":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["你强任你强", "史", "十年老兵", "炮台摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false
