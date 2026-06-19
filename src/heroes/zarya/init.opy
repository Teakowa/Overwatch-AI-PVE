#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitZarya():
    @Name "[zarya/init.opy]: heroInitZarya()"

    eventPlayer.zarya_buff[0] = true
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["Sinatraa", "泡泡摩西", "东北雨姐"]))
    lbl_0:
