#!optimizeStrict

rule "[Cassdy] Peacekeeper Alt Fire":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.isFiringSecondaryFire() == true

    eventPlayer.setDamageDealt(CASSIDY_SECONDARY_LINE_8_DAMAGE_DEALT)
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 0.75)
    eventPlayer.setDamageDealt(100)
