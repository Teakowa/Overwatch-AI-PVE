#!mainFile "../../main.opy"
#!optimizeStrict

rule "[reinhardt/init.opy]: Detect switch to Reinhardt":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero reinhardt

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[reinhardt/init.opy]: Initialize Reinhardt":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #eventPlayer.setKnockbackReceived(REINHARDT_INIT_KNOCKBACK_RECEIVED)
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["小米Su7 Ultra", "Hadi", "冲锋摩西", "抡锤摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false

