rule "[Soldier: 76]: 替代射击":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.dmg_amplification += 300
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setDamageDealt(100 + eventPlayer.dmg_amplification)
    waitUntil(not eventPlayer.isUsingUltimate() or eventPlayer.reset_pvar[0] != false, 8)
    eventPlayer.setDamageDealt(100)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.setPrimaryFireEnabled(true)

rule "[Soldier: 76]: 替代射击":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isFiringSecondaryFire() == true

    waitUntil(not eventPlayer.isFiringSecondaryFire(), 0.496)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0.16)
