#!include "flashbang-stun.opy"
rule "[Cassdy] Peacekeeper Alt Fire":
    @Event eachPlayer
    @Hero cassidy
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    eventPlayer.setDamageDealt(135)
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 0.75)
    eventPlayer.setDamageDealt(100)
#!include "alt-fire-reload.opy"
rule "[Cassdy] ammo restored by kills":
    @Event playerDealtFinalBlow
    @Team 1
    @Hero cassidy
    @Condition isGameInProgress() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAmmo() < eventPlayer.getMaxAmmo()
    
    eventPlayer.setAmmo(0, eventPlayer.getMaxAmmo())
