#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitMauga():
    @Name "[mauga/init.opy]: heroInitMauga()"

    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["黑皮体育生", "黑皮摩西", "SSVGG", "发烧摩西", "小米SU7"]))
    lbl_0:
