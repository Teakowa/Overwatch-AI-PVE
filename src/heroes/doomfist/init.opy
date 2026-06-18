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
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +15%\r\n*受到伤害 -35%\r\n*裂地重拳\r\n 将敌人击飞拉近并使其失控\r\n*悍猛格挡 吸收伤害，最多存储{2}点\r\n*火箭重拳 附带存储的全部伤害 对目标造成额外伤害\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), DoomBuff[0], floor(DoomBuff[1]))
    eventPlayer._reset_requested = false
