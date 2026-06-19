#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitKiriko():
    @Name "[kiriko/init.opy]: heroInitKiriko()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["忍者摩西", "纸钱摩西", "破 摩 十 三 雾"]))
    lbl_0:
