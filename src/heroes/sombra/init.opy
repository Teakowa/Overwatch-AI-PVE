#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitSombra():
    @Name "[sombra/init.opy]: heroInitSombra()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["全民偶像酸不辣", "多少有点LIP", "阳光开朗小女孩", "隐身摩西"]))
    lbl_0:
    getPlayers(eventPlayer.getTeam()).reset_pvar[4] = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).reset_pvar[7] = eventPlayer
