#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Sigma]: Detect switch to Sigma":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero sigma

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Sigma] Initialize":
    @Event eachPlayer
    @Hero sigma
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["核桃摩西", "长 者", "大爷摩西"]))
    lbl_0:
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +25%\r\n*受到伤害 -25%\r\n*超能之球 每3次攻击强化下一次攻击 附带自身当前生命值{1}%伤害（不含临时生命值）\r\n*实验屏障 充能速度提高\r\n*引力乱流 最大生命值伤害增加至 75%\n\n※离开重生室隐藏".format(eventPlayer.getHero(), SigmaBuff[0] * 100)
    eventPlayer._reset_requested = false
