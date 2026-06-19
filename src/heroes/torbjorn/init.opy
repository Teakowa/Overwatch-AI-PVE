#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitTorbjorn():
    @Name "[torbjorn/init.opy]: heroInitTorbjorn()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["你强任你强", "史", "十年老兵", "炮台摩西"]))
    lbl_0:
