#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Zarya]: Detect switch to Zarya":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero zarya

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Zarya] Initialize":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer.zarya_buff[0] = true
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["Sinatraa", "泡泡摩西", "东北雨姐"]))
    lbl_0:
    eventPlayer._reset_requested = false

