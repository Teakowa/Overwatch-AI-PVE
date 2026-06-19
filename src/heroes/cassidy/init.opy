#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitCassidy():
    @Name "[cassidy/init.opy]: heroInitCassidy()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["张三", "天王老子", "KAI了", "麦克雷", "六连摩西"]))
    lbl_0:
