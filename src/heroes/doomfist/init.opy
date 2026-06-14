#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Doomfist]: Detect switch to Doomfist":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero doomfist

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Doomfist] Initialize":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["男拳妈妈", "铁拳不准上桌吃饭", "吃个娜娜", "全部曹飞", "男拳摩西", "曹飞", "你这天使有用吗", "你倒是跑啊", "有人在家吗"]))
    lbl_0:
    getPlayers(eventPlayer.getTeam()).reset_pvar[2] = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).reset_pvar[5] = eventPlayer
    eventPlayer._reset_requested = false
