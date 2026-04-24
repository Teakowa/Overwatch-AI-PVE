#!define TEAM1_RESPAWN_TIME_MODE TEAM1_RESPAWN_TIME_DEFAULT
#!define TEAM2_RESPAWN_TIME_MODE TEAM2_RESPAWN_TIME_DEFAULT
#!define BOOTSTRAP_PLAYER_REINITIALIZE_WAIT_TIMEOUT 5

macro BOOTSTRAP_PLAYER_DEATH_RESET_PRE():
    wait(getAverageServerLoad() / 100)

macro BOOTSTRAP_PLAYER_DEATH_RESET_MODE_HOOK():
    pass

macro BOOTSTRAP_PLAYER_REINITIALIZE_BEFORE_WAIT_UNTIL():
    pass

macro BOOTSTRAP_PLAYER_REINITIALIZE_AFTER_WAIT_UNTIL():
    wait(eventPlayer.getSlot() * 0.5 + getAverageServerLoad() / 100)

macro BOOTSTRAP_PLAYER_REINITIALIZE_SET_RESET_PVAR():
    pass

macro BOOTSTRAP_PLAYER_HERO_SWITCH_RESET_PRE():
    pass

macro BOOTSTRAP_PLAYER_HERO_SWITCH_RESET_POST():
    logToInspector("called reset hero")

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
