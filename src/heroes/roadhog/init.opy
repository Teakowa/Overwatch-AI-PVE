#!mainFile "../../main.opy"
#!optimizeStrict

rule "[roadhog]: Detect switch to roadhog":
    @Event eachPlayer
    @Condition shouldDetectHeroInit(eventPlayer, eventPlayer.getCurrentHero())
    @Hero roadhog

    eventPlayer._last_hero_played = eventPlayer.getCurrentHero()
    eventPlayer._reset_requested = true

rule "[roadhog]":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer._reset_requested != false

    resetHero()
    eventPlayer.setMaxAmmo(0, 5)
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
    eventPlayer.startForcingName(random.choice(["链钩摩西", "肥猪摩西", "小鱿摩西", "奶霸摩西"]))
    #removeTankPassive()
    eventPlayer._reset_requested = false
