#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Sigma]: Detect switch to Sigma":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero sigma

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Sigma] Initialize":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["核桃摩西", "长 者", "大爷摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false
