def resetStatuses():
    @Name "[utilities/reset.opy]: resetStatuses()"
    
    eventPlayer.stopAllDamageOverTime()
    eventPlayer.stopForcingThrottle()
    eventPlayer.freja_buff[0] = 0
    eventPlayer.freja_buff[1] = 0
    clearMoveSpeedDebuffs()
    eventPlayer.taunt = false
    eventPlayer.clearStatusEffect(Status.ASLEEP)
    eventPlayer.clearStatusEffect(Status.BURNING)
    eventPlayer.clearStatusEffect(Status.FROZEN)
    eventPlayer.clearStatusEffect(Status.HACKED)
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    eventPlayer.clearStatusEffect(Status.KNOCKED_DOWN)
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.clearStatusEffect(Status.STUNNED)
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)

