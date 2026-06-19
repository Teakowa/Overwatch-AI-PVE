#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitGenji():
    @Name "[genji/init.opy]: heroInitGenji()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["国服{0}分顶尖镖师".format(Genji[0]), "飞镖摩西", "源神", "忍者摩西", "源氏凯"]))
    lbl_0:
