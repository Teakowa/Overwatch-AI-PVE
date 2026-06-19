#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitSymmetra():
    @Name "[symmetra/init.opy]: heroInitSymmetra()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["性♂感荷官在线烫头", "绿洲城首家赌场", "麻豆传媒摄影师", "烫头摩西"]))
    lbl_0:
    getPlayers(eventPlayer.getTeam()).reset_pvar[3] = eventPlayer
