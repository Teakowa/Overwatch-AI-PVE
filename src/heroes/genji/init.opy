#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Genji]: Detect switch to Genji":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero genji

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Genji]: init":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["国服{0}分顶尖镖师".format(Genji[0]), "飞镖摩西", "源神", "忍者摩西", "源氏凯"]))
    lbl_0:
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +45%\r\n*受到伤害 -50%\r\n*造成击杀后恢复50HP\r\n*影 使下一次近身攻击100%暴击\r\n*闪 冷却时间降低至6秒 持续期间免疫伤害\r\n*龙刃 持续时间增加至8秒\r\n  造成伤害+{1}% 受到伤害 -10%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), Genji[1])
    eventPlayer._reset_requested = false
