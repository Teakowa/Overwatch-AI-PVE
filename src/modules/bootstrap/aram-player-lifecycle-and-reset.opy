#!define TEAM1_RESPAWN_TIME_MODE 2
#!define TEAM2_RESPAWN_TIME_MODE 5
#!define BOOTSTRAP_PLAYER_REINITIALIZE_WAIT_TIMEOUT Math.INFINITY

macro BOOTSTRAP_PLAYER_DEATH_RESET_PRE():
    pass

macro BOOTSTRAP_PLAYER_DEATH_RESET_MODE_HOOK():
    stopAllHealingModifications()

macro BOOTSTRAP_PLAYER_REINITIALIZE_BEFORE_WAIT_UNTIL():
    eventPlayer.extra_hero = true

macro BOOTSTRAP_PLAYER_REINITIALIZE_AFTER_WAIT_UNTIL():
    wait(1)

macro BOOTSTRAP_PLAYER_REINITIALIZE_SET_RESET_PVAR():
    eventPlayer.reset_pvar[0] = true

macro BOOTSTRAP_PLAYER_HERO_SWITCH_RESET_PRE():
    eventPlayer.ram_block_damage = 0
    eventPlayer.sigma_hyperspheres = 0

macro BOOTSTRAP_PLAYER_HERO_SWITCH_RESET_POST():
    pass

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

    BOOTSTRAP_PLAYER_DEATH_RESET_PRE()
    eventPlayer.hudText = ""
    eventPlayer.has_nano = false
    eventPlayer.zarya_buff[0] = true
    eventPlayer.zarya_buff[1] = null
    eventPlayer.ram_block_damage = 0
    eventPlayer.sigma_hyperspheres = 0
    eventPlayer.doom_buff = 0
    BOOTSTRAP_PLAYER_DEATH_RESET_MODE_HOOK()
    resetStats()
    resetStatuses()
    resetFrenemies()

rule "[reset.opy]: Reinitialize hero on new round":
    @Event eachPlayer
    @Condition isMatchBetweenRounds() == true
    @Condition eventPlayer.getHero() != Hero.SOMBRA

    BOOTSTRAP_PLAYER_REINITIALIZE_BEFORE_WAIT_UNTIL()
    waitUntil(not isMatchBetweenRounds(), BOOTSTRAP_PLAYER_REINITIALIZE_WAIT_TIMEOUT)
    BOOTSTRAP_PLAYER_REINITIALIZE_AFTER_WAIT_UNTIL()
    resetHero()
    BOOTSTRAP_PLAYER_REINITIALIZE_SET_RESET_PVAR()
    logToInspector("called init after new round")

rule "[utilities/hero_setup.opy]: Reset and initialize hero on hero switch":
    @Event eachPlayer
    @Condition eventPlayer.reset_pvar[0] != false

    BOOTSTRAP_PLAYER_HERO_SWITCH_RESET_PRE()
    destroyHudText(eventPlayer.ChangelogText1)
    destroyHudText(eventPlayer.ChangelogText2)
    resetHero()
    BOOTSTRAP_PLAYER_HERO_SWITCH_RESET_POST()
