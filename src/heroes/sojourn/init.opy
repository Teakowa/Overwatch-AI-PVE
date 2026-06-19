#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitSojourn():
    @Name "[sojourn/init.opy]: heroInitSojourn()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["跳跳熊", "我超摩西", "我超", "ANS", "MN3", "EVAEL", "没KAI"]))
    lbl_0:
