#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitTorbjorn():
    @Name "[torbjorn/init.opy]: heroInitTorbjorn()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["你强任你强", "史", "中锤", "炮台摩西", "矮人摩西"]))
    lbl_0:
