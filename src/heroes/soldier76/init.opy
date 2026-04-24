#!optimizeStrict

rule "[Soldier: 76]: Detect switch to Soldier 76":
    @Event eachPlayer
    @Hero soldier

    eventPlayer.reset_pvar[0] = true

rule "[Soldier: 76]: Initialize":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["国服顶尖小巴蒂", "跑男摩西", "奶棒摩西", "Kai了", "飞弹摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false
