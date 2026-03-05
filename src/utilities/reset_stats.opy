def resetStats():
    @Name "[utilities/reset.opy]: resetStats()"
    
    eventPlayer.mov_speed_penalty = 0
    eventPlayer.mov_speed_buff = 0
    RESET_STATS_EXTRA()
    eventPlayer.setDamageReceived(100)
    eventPlayer.setProjectileSpeed(100)
    eventPlayer.setProjectileGravity(100)
    eventPlayer.setHealingReceived(100)
    eventPlayer.setKnockbackReceived(100)
    eventPlayer.setKnockbackDealt(100)
    eventPlayer.setGravity(100)
    eventPlayer.setMoveSpeed(100)
