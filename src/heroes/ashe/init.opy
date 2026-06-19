#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitAshe():
    @Name "[ashe/init.opy]: heroInitAshe()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["张三的绯闻女友", "KAI了", "ANS", "Bob摩西"]))
    lbl_0:
