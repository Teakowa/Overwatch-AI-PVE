#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitShion():
    @Name "[shion/init.opy]: heroInitShion()"

    eventPlayer.shion_buff = []
    eventPlayer.setDamageDealt(100)
    eventPlayer.setDamageReceived(100)
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["SPA", "赛博精神病"]))
    lbl_0:
