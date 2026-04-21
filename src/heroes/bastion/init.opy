rule "[bastion/init.opy]: Detect switch to Bastion":
    @Event eachPlayer
    @Hero bastion

    eventPlayer.reset_pvar[0] = true

rule "[bastion/init.opy]: Initialize Bastion":
    @Event eachPlayer
    @Hero bastion
    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["电脑", "嘟嘟嘟嘟嘟", "大炮摩西", "无可奉告"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false
