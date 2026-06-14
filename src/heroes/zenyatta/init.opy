#!mainFile "../../main.opy"
#!optimizeStrict

rule "[zenyatta]: Detect switch to zenyatta":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero zenyatta

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[zenyatta]: init":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer.setMaxAmmo(0, 20)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["武僧", "出家摩西", "机械摩西", "就这", "JJONAK"]))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
    eventPlayer._reset_requested = false
