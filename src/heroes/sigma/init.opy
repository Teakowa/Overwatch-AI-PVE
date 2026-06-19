#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitSigma():
    @Name "[sigma/init.opy]: heroInitSigma()"

    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["核桃摩西", "长 者", "大爷摩西"]))
    lbl_0:
