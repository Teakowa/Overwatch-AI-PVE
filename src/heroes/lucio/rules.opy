#!optimizeStrict

rule "[Lucio]: Soundwave Healing":
    @Event eachPlayer
    @Hero lucio
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) != 0

    heal([player for player in getLivingPlayers(eventPlayer.getTeam()) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) == true and distance(eventPlayer, player) <= 12.5 and player.getNormalizedHealth() < 1], eventPlayer, 60)
    wait(2)
