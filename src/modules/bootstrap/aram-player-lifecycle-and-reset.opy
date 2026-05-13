#!mainFile "../../aramMain.opy"

#!optimizeStrict

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

rule "[utilities/reset]: reset when died":
    @Event playerDied

    eventPlayer.hudText = ""
    eventPlayer.has_nano = false
    eventPlayer.zarya_buff[0] = true
    eventPlayer.zarya_buff[1] = null
    eventPlayer.ram_block_damage = 0
    eventPlayer.sigma_hyperspheres = 0
    eventPlayer.doom_buff = 0
    stopAllHealingModifications()
    resetStats()
    resetStatuses()
    resetFrenemies()

rule "[reset.opy]: Reinitialize hero on new round":
    @Event eachPlayer
    @Condition isMatchBetweenRounds() == true
    @Condition eventPlayer.getHero() != Hero.SOMBRA

    eventPlayer.extra_hero = true
    eventPlayer.aram_extra_pool_applied = false
    waitUntil(not isMatchBetweenRounds(), Math.INFINITY)
    wait(eventPlayer.getSlot() * 10 + getAverageServerLoad() / 100)
    resetHero()
    logToInspector("called init after new round (aram throttled)")

rule "[utilities/hero_setup.opy]: Reset and initialize hero on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.reset_pvar[0] != false

    eventPlayer.ram_block_damage = 0
    eventPlayer.sigma_hyperspheres = 0
    destroyHudText(eventPlayer.ChangelogText1)
    destroyHudText(eventPlayer.ChangelogText2)
    resetHero()

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