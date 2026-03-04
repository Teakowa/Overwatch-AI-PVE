rule "[wuyang/init.opy]: Detect switch to wuyang":
    @Event eachPlayer
    @Hero wuyang
    @Condition eventPlayer.reset_pvar[10] != eventPlayer.getHero()

    eventPlayer.reset_pvar[10] = eventPlayer.getHero()
    eventPlayer.reset_pvar[0] = true


rule "[wuyang/init.opy]: Initialize wuyang":
    @Event eachPlayer
    @Hero wuyang
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    #eventPlayer.custom_hp_pvar[0] = 0
    #eventPlayer.custom_hp_pvar[1] = 0
    #eventPlayer.custom_hp_pvar[2] = 0
    #applyCustomHp()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["玩水摩西", "成都摩西"]))
    lbl_0:
    eventPlayer.reset_pvar[0] = false


