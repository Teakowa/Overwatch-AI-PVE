#!mainFile "../../main.opy"
#!optimizeStrict

def heroInitJunkrat():
    @Name "[junkrat/init.opy]: heroInitJunkrat()"

    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["拉 史 大 王", "拉 史 摩 西", "鼠鼠摩西", "鸭脖摩西", "夹子摩西"]))
    lbl_0:
