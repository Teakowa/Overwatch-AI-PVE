rule "[Doomfist]: Detect switch to Doomfist":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.reset_pvar[10] != eventPlayer.getHero()

    eventPlayer.reset_pvar[10] = eventPlayer.getHero()
    eventPlayer.reset_pvar[0] = true


rule "[Doomfist] Initialize":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.reset_pvar[0] != false
    
    resetHero()
    eventPlayer.custom_hp_pvar[0] = 300
    eventPlayer.custom_hp_pvar[1] = 100
    eventPlayer.custom_hp_pvar[2] = 0
    applyCustomHp()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["男拳妈妈", "铁拳不准上桌吃饭", "吃个娜娜", "全部曹飞", "男拳摩西", "曹飞", "你这天使有用吗", "你倒是跑啊", "有人在家吗"]))
    lbl_0:
    getPlayers(eventPlayer.getTeam()).reset_pvar[2] = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).reset_pvar[5] = eventPlayer
    eventPlayer.reset_pvar[0] = false


