#!mainFile "../../main.opy"
#!optimizeStrict

rule "[torbjorn/init.opy]: Detect switch to Torbjorn":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero torbjorn

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[torbjorn/init.opy]: Initialize Torbjorn":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer._reset_requested != false

    resetHero()
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.startForcingName(random.choice(["你强任你强", "史", "十年老兵", "炮台摩西"]))
    lbl_0:
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害 -20%\r\n{2} 熔火核心\r\n  充能速度降低30%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.PRIMARY_FIRE), abilityIconString(eventPlayer.getHero(), Button.ULTIMATE))
    eventPlayer._reset_requested = false
