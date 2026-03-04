def resetHero():
    @Name "[utilities/reset.opy]: resetHero()"
    
    destroyHudText(eventPlayer.reaper_buff[2])
    destroyHudText(eventPlayer.ram_block_damage_hud)
    destroyHudText(eventPlayer.sigma_hyperspheres_hud)
    destroyHudText(eventPlayer.doom_buff_hud)
    eventPlayer.reaper_buff[2] = 0
    eventPlayer.hudText = ""
    eventPlayer.ram_block_damage = 0
    eventPlayer.sigma_hyperspheres = 0
    eventPlayer.doom_buff = 0
    eventPlayer.reaper_buff[1] = 0
    eventPlayer.dmg_reduction = 0
    eventPlayer.dmg_amplification = 0
    eventPlayer.has_nano = false
    clearCustomHp()
    resetStats()
    resetStatuses()
    resetFrenemies()
    enableAllAbilities()
    #wait at least 1 tick
    wait()

