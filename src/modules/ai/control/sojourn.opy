#!mainFile "../../../main.opy"
#!optimizeStrict

# The Ability 1 proximity gate keeps a living-only scan
# (len([p for p in getLivingPlayers(opposite) if distance <= 22]) > 0).
# Alternatives were evaluated and rejected: botHasNearbyEnemy and
# getPlayersInRadius are dead-inclusive; botTarget/botTemp require LoS and
# are unbounded in range, so they can miss a hidden enemy within 22m or
# select one far away. Caching a living proximity fact in the shared
# perception cycle would add work to a recurring 0.512s rule for every
# perception-listed hero. The scan is bounded by the enemy roster and runs
# only behind the spawned/cooldown/alive gates on damage events, so it is
# retained unchanged.

rule "[AI/control]: Sojourn Ability 1":
    @Event playerTookDamage
    @Team 1
    @Hero sojourn
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.isAlive() == true
    @Condition len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer, player) <= 22]) > 0
    
    eventPlayer.startForcingButton(Button.ABILITY_1)
    wait(0.75)
    eventPlayer.stopForcingButton(Button.ABILITY_1)
    eventPlayer.forceButtonPress(Button.JUMP)
    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    wait(0.25)


