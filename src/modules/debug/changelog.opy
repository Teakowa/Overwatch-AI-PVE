#!mainFile "../../main.opy"
#!optimizeStrict

rule "Changelog":
    @Event eachPlayer
    @Team 2
    @Condition isGameInProgress() != true
    @Condition eventPlayer.isInSpawnRoom() == true
    
    wait(WAIT_SHORT_FRAME)
    changelogText()
