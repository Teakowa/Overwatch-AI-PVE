#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Shion/init.opy]: Detect switch to Shion":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero shion

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[Shion/init.opy]: Initialize Shion":
    @Event eachPlayer
    @Hero shion
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer.shion_buff[0] = 0
    eventPlayer.shion_buff[1] = false
    eventPlayer.shion_buff[2] = false
    eventPlayer.shion_buff[3] = 0
    eventPlayer.shion_buff[4] = false
    eventPlayer.setDamageDealt(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer._reset_requested = false
    if eventPlayer.getTeam() == Team.2:
        wait(WAIT_SHORT_FRAME)
        if eventPlayer.getCurrentHero() == Hero.SHION:
            eventPlayer.changelog_body = "\r\n●{0}\r\n*造成伤害时获得1层狂势 满层后8秒内：增伤{1}% 减伤{2}%\r\n{3} 交叉枪决 完成击杀后重置冷却\r\n{4} 每次击杀返还 {5}% 充能\n\n※※离开重生室隐藏".format(eventPlayer.getHero(), ShionBuff[1], ShionBuff[2], abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE), abilityIconString(eventPlayer.getHero(), Button.ULTIMATE), ShionBuff[4])
