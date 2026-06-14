#!mainFile "../../main.opy"
#!optimizeStrict

rule "[D.Va]: Detect switch to D.Va":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero dva
    @Condition eventPlayer.isInAlternateForm() == false

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[D.Va] Initialize":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #removeTankPassive()
    eventPlayer._reset_requested = false
