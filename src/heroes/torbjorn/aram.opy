#!mainFile "../../aramMain.opy"
#!optimizeStrict

# torbjorn aram-only forge hammer suite

rule "[Torbjörn]: Forge Hammer":
    @Event eachPlayer
    @Hero torbjorn
    @Condition (eventPlayer.isInAlternateForm() and eventPlayer.getCurrentWeapon() == 2) == true

    eventPlayer.setDamageDealt(TORBJORN_ARAM_DAMAGE_DEALT)
    waitUntil(not (eventPlayer.isInAlternateForm() and eventPlayer.getCurrentWeapon() == 2), 999999986991104)
    eventPlayer.setDamageDealt(100)
    wait(1)

rule "[Torbjörn]: Forge Hammer":
    @Event playerDealtDamage
    @Hero torbjorn
    @Condition (eventPlayer.isInAlternateForm() and eventPlayer.getCurrentWeapon() == 2) == true
    @Condition eventAbility == Button.PRIMARY_FIRE

    heal(eventPlayer, eventPlayer, eventDamage * TORBJORN_ARAM_EVENT_DAMAGE_HEAL_SCALAR)

rule "[Torbjörn]: Forge Hammer":
    @Event eachPlayer
    @Hero torbjorn
    @Condition eventPlayer.isUsingAbility2() == true

    eventPlayer.addHealthPool(Health.NORMAL, TORBJORN_ARAM_NORMAL_HEALTH_POOL_AMOUNT, false, false)
    eventPlayer.heart_steel = getLastCreatedHealthPool()
    waitUntil(not eventPlayer.isUsingAbility2(), 8)
    removeHealthPool(eventPlayer.heart_steel)
