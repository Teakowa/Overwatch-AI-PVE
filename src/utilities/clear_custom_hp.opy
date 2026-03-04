def clearCustomHp():
    @Name "[utilities/custom_hp.opy]: clearCustomHp()"
    
    eventPlayer.reset_pvar[8] = false
    eventPlayer.removeAllHealthPools()
    wait()
    eventPlayer.custom_hp_pvar[0] = 0
    eventPlayer.custom_hp_pvar[1] = 0
    eventPlayer.custom_hp_pvar[2] = 0
    eventPlayer.custom_hp_pvar[3] = eventPlayer.getMaxHealthOfType(Health.NORMAL)
    eventPlayer.custom_hp_pvar[4] = eventPlayer.getMaxHealthOfType(Health.ARMOR)
    eventPlayer.custom_hp_pvar[5] = eventPlayer.getMaxHealthOfType(Health.SHIELDS)
    eventPlayer.custom_hp_pvar[6] = 1
    eventPlayer.reset_pvar[8] = true
