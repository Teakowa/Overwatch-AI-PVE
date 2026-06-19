#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitFreja():
    @Name "[freja/init.opy]: heroInitFreja()"

    eventPlayer.setProjectileSpeed(FREJA_INIT_PROJECTILE_SPEED)
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["ANS", "射 爆", "拉矢摩西"]))
    lbl_0:
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).reset_pvar[11] = eventPlayer
