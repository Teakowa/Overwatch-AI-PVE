rule "[utilities/reset]: setup var when player joins lobby":
    @Event eachPlayer
    
    resetFrenemies()

rule "[utilities/reset]: Default respawn time":
    @Event eachPlayer
    @Team 1
    
    eventPlayer.setRespawnTime(TEAM1_RESPAWN_TIME_DEFAULT)

rule "[utilities/reset]: Default respawn time":
    @Event eachPlayer
    @Team 2
    
    eventPlayer.setRespawnTime(TEAM2_RESPAWN_TIME_DEFAULT)

rule "[utilities/reset]: reset when died":
    @Event playerDied
    
    wait(getAverageServerLoad() / 100)
    eventPlayer.hudText = ""
    eventPlayer.has_nano = false
    eventPlayer.zarya_buff[0] = true
    eventPlayer.zarya_buff[1] = null
    eventPlayer.ram_block_damage = 0
    eventPlayer.sigma_hyperspheres = 0
    eventPlayer.doom_buff = 0
    resetStats()
    resetStatuses()
    resetFrenemies()

def applySignedMoveSpeed():
    @Name "[utilities/move_speed.opy]: applySignedMoveSpeed()"
    
    eventPlayer.setMoveSpeed(min(max(100 + eventPlayer.mov_speed_buff, 20), 200))

def clearMoveSpeedDebuffs():
    @Name "[utilities/move_speed.opy]: clearMoveSpeedDebuffs()"
    
    eventPlayer.brigitte_buff[0] = false
    eventPlayer.orisa_buff = false
    eventPlayer.wuyang_buff[3] = false
    eventPlayer.wuyang_buff[4] = false
    eventPlayer.mov_speed_penalty = 0
    eventPlayer.mov_speed_buff = 0
    applySignedMoveSpeed()

rule "[reset.opy]: Reinitialize hero on new round":
    @Event eachPlayer
    @Condition isMatchBetweenRounds() == true
    @Condition eventPlayer.getHero() != Hero.SOMBRA
    
    waitUntil(not isMatchBetweenRounds(), Math.INFINITY)
    wait(eventPlayer.getSlot() * 0.032)
    wait(1)
    resetHero()
    eventPlayer.reset_pvar[0] = true
    logToInspector("called init after new round")

rule "[utilities/hero_setup.opy]: Reset and initialize hero on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.reset_pvar[0] != false
    
    destroyHudText(eventPlayer.ChangelogText1)
    destroyHudText(eventPlayer.ChangelogText2)
    resetHero()
    logToInspector("called reset hero")
