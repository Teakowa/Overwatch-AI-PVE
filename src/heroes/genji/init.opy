#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Genji]: Detect switch to Genji":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero genji

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Genji]: init":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["国服{0}分顶尖镖师".format(Genji[0]), "飞镖摩西", "源神", "忍者摩西", "源氏凯"]))
    lbl_0:
    eventPlayer._reset_requested = false
