#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitJuno():
    @Name "[juno/init.opy]: heroInitJuno()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["轨投摩西", "香香糯糯", "火星摩西", "大头摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[6].reset_pvar[9] = eventPlayer
