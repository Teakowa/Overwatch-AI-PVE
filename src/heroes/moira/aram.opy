#!mainFile "../../aramMain.opy"
#!optimizeStrict

rule "[Moira][ARAM]: Back to Basics":
    @Event playerEarnedElimination
    @Team 1
    @Hero moira

    eventPlayer.setDamageDealt((100 + 50) + eventPlayer.getStatistic(Stat.ELIMINATIONS) * 2.5)
    eventPlayer.setHealingDealt((100 + 50) + eventPlayer.getStatistic(Stat.ELIMINATIONS) * 2.5)
    eventPlayer.setMaxHealth((100 + 50) + eventPlayer.getStatistic(Stat.ELIMINATIONS) * 2.5)

rule "[Moira][ARAM]: Back to Basics":
    @Event playerEarnedElimination
    @Team 2
    @Hero moira

    eventPlayer.setDamageDealt((100 + 50) + eventPlayer.getStatistic(Stat.ELIMINATIONS) * 2)
    eventPlayer.setHealingDealt((100 + 50) + eventPlayer.getStatistic(Stat.ELIMINATIONS) * 2)
    eventPlayer.setMaxHealth((100 + 50) + eventPlayer.getStatistic(Stat.ELIMINATIONS) * 2)
