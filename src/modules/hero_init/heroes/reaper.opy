rule "[reaper/init.opy]: Detect switch to Reaper":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.reset_pvar[10] != eventPlayer.getHero()

    eventPlayer.reset_pvar[10] = eventPlayer.getHero()
    eventPlayer.reset_pvar[0] = true


rule "[reaper/init.opy]: Initialize Reaper":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 275
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["滚筒洗衣机", "转圈摩西", "龙卷风摩西", "哈哈摩西", "菜就多练"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


