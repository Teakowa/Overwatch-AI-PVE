rule "[Orisa]: Fortify provides 100 temporary armor":
    @Event eachPlayer
    @Hero orisa
    @Condition Orisa_Fortify[0] != 0
    @Condition any([i == true for i in [eventPlayer.isUsingAbility1(), eventPlayer.isUsingUltimate()]]) == true
    
    wait(0.16)
    eventPlayer.unaffected = true
    eventPlayer.hazard_buff[0] = false
    eventPlayer.zarya_graviton_buff[0] = false
    eventPlayer.brigitte_buff[0] = false
    eventPlayer.orisa_buff = false
    eventPlayer.addHealthPool(Health.ARMOR, Orisa_Fortify[0], true, false)
    eventPlayer.orisa_fortify_armor_id = getLastCreatedHealthPool()
    eventPlayer.startHealingOverTime(eventPlayer, eventPlayer.getMaxHealth() * 0.1, 4)
    if eventPlayer.isUsingAbility1() == true:
        waitUntil(not eventPlayer.isUsingAbility1(), 999999986991104)
    else:
        waitUntil(not eventPlayer.isUsingUltimate(), 999999986991104)
    removeHealthPool(eventPlayer.orisa_fortify_armor_id)
    eventPlayer.unaffected = false
