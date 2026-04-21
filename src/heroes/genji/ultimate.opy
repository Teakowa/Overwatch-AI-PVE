rule "[Genji] Dragonblade Healing":
    @Event playerDealtDamage
    @Hero genji
    @Condition eventAbility == Button.ULTIMATE

    heal(eventPlayer, eventPlayer, eventDamage)

rule "[Genji] Dragonblade Damage Fix":
    @Event eachPlayer
    @Hero genji
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.setDamageDealt(100 + Genji[1])
    eventPlayer.setDamageReceived(90)
    waitUntil(not eventPlayer.isUsingUltimate(), 8)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setDamageReceived(100)
