rule "Changelog":
    @Event eachPlayer
    @Team 2
    @Condition isGameInProgress() != true
    @Condition eventPlayer.isInSpawnRoom() == true
    
    wait(WAIT_SHORT_FRAME)
    changelogText()
    waitUntil(not eventPlayer.isInSpawnRoom(), Math.INFINITY)
    destroyHudText(eventPlayer.ChangelogText1)
    destroyHudText(eventPlayer.ChangelogText2)

