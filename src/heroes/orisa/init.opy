#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitOrisa():
    @Name "[orisa/init.opy]: heroInitOrisa()"

    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["命运羊驼", "美羊羊", "唯一真神", "标枪摩西", "小米Su7 Ultra"]))
    lbl_0:
