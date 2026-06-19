#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitDoomfist():
    @Name "[doomfist/init.opy]: heroInitDoomfist()"

    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["男拳妈妈", "铁拳不准上桌吃饭", "吃个娜娜", "全部曹飞", "男拳摩西", "曹飞", "你这天使有用吗", "你倒是跑啊", "有人在家吗"]))
    lbl_0:
    getPlayers(eventPlayer.getTeam()).reset_pvar[2] = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).reset_pvar[5] = eventPlayer
