#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitBrigitte():
    @Name "[brigitte/init.opy]: heroInitBrigitte()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["那个女人", "炖鸡摩西", "持盾摩西", "贴膜摩西", "护 娜 十 三 锤", "泰格"]))
    lbl_0:
    getPlayers(eventPlayer.getTeam()).reset_pvar[1] = eventPlayer
