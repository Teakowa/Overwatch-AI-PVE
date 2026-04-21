rule "[reaper/init.opy]: Detect switch to Reaper":

    @Event eachPlayer

    @Hero reaper

    eventPlayer.reset_pvar[0] = true

rule "[reaper/init.opy]: Initialize Reaper":

    @Event eachPlayer

    @Hero reaper

    @Condition eventPlayer.reset_pvar[0] != false

    resetHero()

    if eventPlayer.getTeam() != Team.1:

        goto lbl_0

    eventPlayer.startForcingName(random.choice(["滚筒洗衣机", "转圈摩西", "龙卷风摩西", "哈哈摩西", "菜就多练"]))

    lbl_0:

    eventPlayer.reset_pvar[0] = false
