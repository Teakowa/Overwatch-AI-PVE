#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Ramattra]: Detect switch to Ramattra":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero ramattra

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Ramattra] Initialize":
    @Event eachPlayer
    @Hero ramattra
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #removeTankPassive()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["我 扛 不 住 辣", "鲑鱼大帝", "Suffer as i have!", "抱头摩西", "痛苦摩西"]))
    lbl_0:
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +20%\r\n*受到伤害 -35%\r\n*吞噬漩涡 冷却时间降低\r\n* 诛 -{1}%受到伤害 +30%移速 70%击退抵抗\r\n回复{2}%已造成伤害的生命值\n\n※离开重生室隐藏".format(eventPlayer.getHero(), Ram_Annihilation[4], Ram_Annihilation[1] * 100)
    eventPlayer._reset_requested = false
