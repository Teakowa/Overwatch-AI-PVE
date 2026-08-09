#!mainFile "../../aramMain.opy"
#!optimizeStrict

rule "[Moira][ARAM]: Back to Basics":
    @Event playerEarnedElimination
    @Hero moira

    eventPlayer.setDamageDealt(125 + eventPlayer.getStatistic(Stat.ELIMINATIONS))
    eventPlayer.setHealingDealt(125 + eventPlayer.getStatistic(Stat.ELIMINATIONS))
    eventPlayer.setMaxHealth(125 + eventPlayer.getStatistic(Stat.ELIMINATIONS))
