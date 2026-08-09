#!mainFile "../../aramMain.opy"
#!optimizeStrict

rule "[Moira][ARAM]: Back to Basics":
    @Event playerEarnedElimination
    @Hero moira

    eventPlayer.setDamageDealt(125 + eventPlayer.getStatistic(Stat.ELIMINATIONS))
    eventPlayer.setHealingDealt(125 + eventPlayer.getStatistic(Stat.ELIMINATIONS))
    eventPlayer.setMaxHealth(125 + eventPlayer.getStatistic(Stat.ELIMINATIONS))

rule "[Moira][ARAM]: Disable Coalescence":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer._reset_requested == false

    eventPlayer.setUltEnabled(false)
    eventPlayer.disallowButton(Button.ULTIMATE)
    waitUntil(eventPlayer._reset_requested != false or not isHero(eventPlayer, Hero.MOIRA), Math.INFINITY)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.setUltEnabled(true)
