def applyCustomHp():
    @Name "[utilities/custom_hp.opy]: applyCustomHp()"
    
    if eventPlayer.getMaxHealthOfType(Health.NORMAL) == eventPlayer.custom_hp_pvar[0] and eventPlayer.getMaxHealthOfType(Health.ARMOR) == eventPlayer.custom_hp_pvar[1] and eventPlayer.getMaxHealthOfType(Health.SHIELDS) == eventPlayer.custom_hp_pvar[2]:
        return
    #Find minimum hp scalar value that ensures
    #the scaled health/armor/shields is less or equal to
    #the desired custom health/armor/shield value
    eventPlayer.custom_hp_pvar[6] = min(min(eventPlayer.custom_hp_pvar[0] / eventPlayer.custom_hp_pvar[3] if eventPlayer.custom_hp_pvar[3] > 0 else CUSTOM_HP_SCALAR_FALLBACK, eventPlayer.custom_hp_pvar[1] / eventPlayer.custom_hp_pvar[4] if eventPlayer.custom_hp_pvar[4] > 0 else CUSTOM_HP_SCALAR_FALLBACK), eventPlayer.custom_hp_pvar[2] / eventPlayer.custom_hp_pvar[5] if eventPlayer.custom_hp_pvar[5] > 0 else CUSTOM_HP_SCALAR_FALLBACK)
    eventPlayer.setMaxHealth(100 * eventPlayer.custom_hp_pvar[6])
    waitUntil(eventPlayer.getMaxHealth() != eventPlayer.custom_hp_pvar[3] + eventPlayer.custom_hp_pvar[4] + eventPlayer.custom_hp_pvar[5], 1)
    if eventPlayer.custom_hp_pvar[0] - eventPlayer.getMaxHealthOfType(Health.NORMAL) >= 1:
        eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.custom_hp_pvar[0] - eventPlayer.getMaxHealthOfType(Health.NORMAL), true, false)
    if eventPlayer.custom_hp_pvar[1] - eventPlayer.getMaxHealthOfType(Health.ARMOR) >= 1:
        eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.custom_hp_pvar[1] - eventPlayer.getMaxHealthOfType(Health.ARMOR), true, false)
    if eventPlayer.custom_hp_pvar[2] - eventPlayer.getMaxHealthOfType(Health.SHIELDS) >= 1:
        eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.custom_hp_pvar[2] - eventPlayer.getMaxHealthOfType(Health.SHIELDS), true, false)

