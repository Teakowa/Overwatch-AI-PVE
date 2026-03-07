#!define TEAM1_RESPAWN_TIME_MODE 2
#!define TEAM2_RESPAWN_TIME_MODE 5

rule "[utilities/reset]: setup var when player joins lobby":
    @Event eachPlayer
    
    resetFrenemies()

rule "[utilities/reset]: Default respawn time":
    @Event eachPlayer
    @Team 1
    
    eventPlayer.setRespawnTime(TEAM1_RESPAWN_TIME_MODE)

rule "[utilities/reset]: Default respawn time":
    @Event eachPlayer
    @Team 2
    
    eventPlayer.setRespawnTime(TEAM2_RESPAWN_TIME_MODE)
