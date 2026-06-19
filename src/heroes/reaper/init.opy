#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitReaper():
    @Name "[reaper/init.opy]: heroInitReaper()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["滚筒洗衣机", "转圈摩西", "龙卷风摩西", "哈哈摩西", "菜就多练"]))
    lbl_0:
