#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Freja/init.opy]: Detect switch to Freja":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero freja

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Freja/init.opy]: Initialize Freja":
    @Event eachPlayer
    @Hero freja
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer.setProjectileSpeed(FREJA_INIT_PROJECTILE_SPEED)
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["ANS", "射 爆", "拉矢摩西"]))
    lbl_0:
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).reset_pvar[11] = eventPlayer
    eventPlayer._reset_requested = false

