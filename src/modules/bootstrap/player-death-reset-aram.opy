macro BOOTSTRAP_PLAYER_DEATH_RESET_PRE():
    pass

macro BOOTSTRAP_PLAYER_DEATH_RESET_MODE_HOOK():
    stopAllHealingModifications()

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
