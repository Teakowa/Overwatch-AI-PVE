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
