#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Moira]: Detect switch to Moira":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero moira

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Moira] Initialize":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["五  金  上  将", "五金上将莫伊拉", "五金摩西", "生化摩西"]))
    lbl_0:
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.MOIRA:
            eventPlayer.changelog_body = "\r\n{0}\r\n{1}\r\n{2}\n\n※※离开重生室隐藏".format("●{0}\r\n 受到伤害-10%\r\n造成治疗+60%".format(eventPlayer.getHero()), "{0} 技能期间回复45%已损失生命值".format(abilityIconString(eventPlayer.getHero(), Button.ABILITY_1)), "")
