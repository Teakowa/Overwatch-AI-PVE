#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Mauga]: Detect switch to Mauga":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero mauga

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Mauga] Initialize":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["黑皮体育生", "黑皮摩西", "SSVGG", "Seiseiguigeigei", "发烧摩西", "小米SU7"]))
    lbl_0:
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +25%\r\n*受到伤害 -35%\r\n*狂战士之魂（被动） 受到致命伤害触发 回复100%最大生命值并进入狂战士状态\r\n*蛮力冲撞 击倒时间提高至2秒\r\n*心脏过载 冷却时间降低至约11.8秒 治疗量+100% 伤害减免提高至55%\r\n*笼中斗 持续时间提高并免疫暴击\r\n".format(eventPlayer.getHero())
    eventPlayer._reset_requested = false
