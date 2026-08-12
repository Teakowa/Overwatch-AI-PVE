#!mainFile "../../main.opy"
#!optimizeStrict

rule "[fixture]: phase-gated long-lived persistent action":
    @Event eachPlayer
    @Team 1
    @Condition isGameInProgress() == true
    @Condition not isMatchBetweenRounds()

    eventPlayer.startHealingOverTime(eventPlayer, 3600, 8)
