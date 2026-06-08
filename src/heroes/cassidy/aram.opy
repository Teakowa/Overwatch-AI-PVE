#!optimizeStrict



rule "[Cassdy] Peacekeeper Alt Fire":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.isFiringSecondaryFire() == true

    eventPlayer.setDamageDealt(CASSIDY_ARAM_LINE_10_DAMAGE_DEALT)
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 0.75)
    eventPlayer.setDamageDealt(100)

#!include "primary.opy"
#!include "ability2.opy"