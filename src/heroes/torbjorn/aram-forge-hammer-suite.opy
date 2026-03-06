# torbjorn aram-only forge hammer suite

rule "[Torbjörn]: Forge Hammer":
    @Event eachPlayer
    @Hero torbjorn
    @Condition (eventPlayer.isInAlternateForm() and eventPlayer.getCurrentWeapon() == 2) == true
    
    eventPlayer.setDamageDealt(300)
    waitUntil(not (eventPlayer.isInAlternateForm() and eventPlayer.getCurrentWeapon() == 2), 999999986991104)
    eventPlayer.setDamageDealt(100)
    wait(1)

rule "[Torbjörn]: Forge Hammer":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.addHealthPool(Health.NORMAL, 100, false, false)
    eventPlayer.heart_steel = getLastCreatedHealthPool()
    waitUntil(not eventPlayer.isUsingAbility2(), 8)
    removeHealthPool(eventPlayer.heart_steel)
