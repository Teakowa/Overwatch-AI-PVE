#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Sombra]: Detect switch to Sombra":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero sombra

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Sombra] Initialize":
    @Event eachPlayer
    @Hero sombra
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["全民偶像酸不辣", "多少有点LIP", "阳光开朗小女孩", "隐身摩西"]))
    lbl_0:
    getPlayers(eventPlayer.getTeam()).reset_pvar[4] = eventPlayer
    getPlayers(getOppositeTeam(eventPlayer.getTeam())).reset_pvar[7] = eventPlayer
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.SOMBRA:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -22%\r\n*位移传动  击杀后重置CD\r\n*黑客入侵  沉默敌人6秒并使敌方额外减疗{1}%\r\n*电磁脉冲  充能速度提高7%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), SombraBuff[0])
