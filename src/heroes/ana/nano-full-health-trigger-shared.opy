rule "[Ana]: Damage Full Health Allies So Nano Can Heal":
    @Event eachPlayer
    @Hero ana
    @Condition eventPlayer.getUltCharge() == 100

    waitUntil(eventPlayer.getUltCharge() == 0, 99999)
    eventPlayer.nano_full_health = [i for i in eventPlayer.getPlayerClosestToReticle(eventPlayer.getTeam()) if i.getHealth() >= i.getMaxHealth()]
    damage(eventPlayer.nano_full_health, null, 0.05)
    wait(0.216)
    heal(eventPlayer.nano_full_health, null, 0.05)
    eventPlayer.nano_full_health = null
