#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitZenyatta():
    @Name "[zenyatta/init.opy]: heroInitZenyatta()"

    eventPlayer.setMaxAmmo(0, 20)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["武僧", "出家摩西", "佛珠摩西", "就这", "JJONAK"]))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
