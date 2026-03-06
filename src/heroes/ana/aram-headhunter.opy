rule "[Ana]: Headhunter":
    @Event playerDealtDamage
    @Team 2
    @Hero ana
    @Condition eventWasCriticalHit == true
    @Disabled
    
    if eventPlayer.getNormalizedHealth() != 1:
        eventPlayer.startHealingOverTime(eventPlayer, 0.625, ceil(eventDamage * 31.25 * 10))
    else:
        ([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) == true and player != eventPlayer]).startHealingOverTime(eventPlayer, 0.625, ceil(eventDamage * 31.25 * 10) / (len([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) == true and player != eventPlayer])))
    wait(0.625)
