#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Sojourn]: Detect switch to Sojourn":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero sojourn

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Sojourn] Initialize":
    @Event eachPlayer
    @Hero sojourn
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["跳跳熊", "我超摩西", "我超", "ANS", "MN3", "EVAEL", "没KAI"]))
    lbl_0:
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +30%\r\n*电磁炮充能速度+25%\r\n*电磁炮-充能射击 处决生命值低于{2}%的敌人\r\n *机体超频 强化充能射击：处决阈值增加至20%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_2), SojournBuff[0] * 100)
    eventPlayer._reset_requested = false
