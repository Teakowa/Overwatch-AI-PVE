#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitBaptiste():
    @Name "[baptiste/init.opy]: heroInitBaptiste()"

    eventPlayer.setMaxAmmo(0, 45)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
    eventPlayer.setMaxAmmo(1, 25)
    eventPlayer.setAmmo(1, eventPlayer.getMaxAmmo(1))
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["大 76", "Kai了", "天使", "飞饼摩西", "锁头摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
