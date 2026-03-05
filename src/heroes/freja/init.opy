#!include "init-detect.opy"

rule "[Freja/init.opy]: Initialize Freja":
    @Event eachPlayer
    @Hero freja
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.setProjectileSpeed(500)
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["ANS", "射 爆", "拉矢摩西"]))
    lbl_0:
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).reset_pvar[11] = eventPlayer
    eventPlayer.reset_pvar[0] = false


