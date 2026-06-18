#!mainFile "../../main.opy"
#!optimizeStrict

rule "[pharah/init.opy]: Detect switch to Pharah":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero pharah

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[pharah/init.opy]: Initialize Pharah":
    @Event eachPlayer
    @Hero pharah
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    lbl_0:
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.PHARAH:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 +35%\r\n*受到伤害 -15%\r\n{1} 推进背包\r\n  补充全部燃料并额外获得75%燃料\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.ABILITY_1))
