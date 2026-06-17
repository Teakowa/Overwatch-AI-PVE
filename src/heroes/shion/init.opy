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
    if eventPlayer.getTeam() != Team.1:
        goto lbl_0
    eventPlayer.heroNum = BotHeroArray.index(eventPlayer.getHero())
    lbl_0:
    eventPlayer.shion_buff[0] = 0
    eventPlayer.shion_buff[1] = false
    eventPlayer.shion_buff[2] = false
    eventPlayer.shion_buff[3] = false
    eventPlayer.setDamageDealt(100)
    eventPlayer._reset_requested = false
