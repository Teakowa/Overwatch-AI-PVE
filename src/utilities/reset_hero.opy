#!mainFile "../main.opy"
def resetCombatState():
    @Name "[utilities/reset.opy]: resetCombatState()"

    eventPlayer.reaper_buff[2] = 0
    eventPlayer.hudText = ""
    eventPlayer.has_nano = false
    eventPlayer.zarya_buff[0] = true
    eventPlayer.zarya_buff[1] = null
    eventPlayer.ram_block_damage = 0
    eventPlayer.sigma_hyperspheres = 0
    eventPlayer.doom_buff = 0
    eventPlayer.reaper_buff[1] = 0
    eventPlayer.dmg_reduction = 0
    eventPlayer.dmg_amplification = 0

def resetHero():
    @Name "[utilities/reset.opy]: resetHero()"
    
    resetCombatState()
    RESET_HERO_EXTRA_BEFORE_CLEAR()
    clearCustomHp()
    resetStats()
    resetStatuses()
    resetFrenemies()
    enableAllAbilities()
    #wait at least 1 tick
    RESET_HERO_WAIT()
