#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitVenture():
    @Name "[venture/init.opy]: heroInitVenture()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["钻地摩西", "丁真摩西"]))
    lbl_0:
