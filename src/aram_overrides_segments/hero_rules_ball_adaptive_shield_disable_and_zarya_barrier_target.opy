rule "[Wrecking Ball] Disable Adaptive Shield for allies":
    @Event eachPlayer
    @Hero wreckingBall
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingAbility2() == true
    @Disabled
    
    eventPlayer.disallowButton(Button.ABILITY_2)
    waitUntil(not eventPlayer.isUsingAbility2() or eventPlayer.reset_pvar[0] != false, 7)
    eventPlayer.allowButton(Button.ABILITY_2)

rule "[Zarya]: Projected Barrier Target":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.isUsingAbility2() == true
    
    [i for i in sorted(getLivingPlayers(eventPlayer.getTeam()), lambda player: angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getPosition(), player.getPosition()))) if i.hasStatus(Status.INVINCIBLE)][0].zarya_barrier_shields[0] = true

