#!mainFile "../../main.opy"
#!optimizeStrict

rule "[D.Va]: Detect switch to D.Va":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero dva
    @Condition eventPlayer.isInAlternateForm() == false

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[D.Va] Initialize":
    @Event eachPlayer
    @Hero dva
    @Condition eventPlayer._reset_requested != false

    resetHero()
    #removeTankPassive()
    if eventPlayer.getTeam() == Team.2:
        eventPlayer.changelog_body = "\r\n●\"{0}\"\r\n*造成伤害 +35%\r\n*受到伤害 -25%\r\n{1} 防御矩阵\r\n持续时间提高至约2.7秒\r\n 充能速度提高100%\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE))
    eventPlayer._reset_requested = false
