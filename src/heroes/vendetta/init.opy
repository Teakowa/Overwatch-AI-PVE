#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitVendetta():
    @Name "[vendetta/init.opy]: heroInitVendetta()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["大剑摩西", "一刀摩西"]))
    lbl_0:
