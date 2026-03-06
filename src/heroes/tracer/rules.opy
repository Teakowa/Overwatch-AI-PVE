#!include "10-recall-healing.opy"
rule "[Tracer] Instant Respawn":
    @Event playerDied
    @Hero tracer
    
    wait(WAIT_SHORT_FRAME)
    eventPlayer.respawn()
    eventPlayer.setAbilityCharge(Button.ABILITY_1, 3)
rule "[Tracer] Pulse Bomb Damage":
    @Event playerDealtDamage
    @Hero tracer
    #@Condition attacker.getHero() == Hero.TRACER == true
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 10
    
    damage(victim, attacker, ceil(eventDamage))
#!include "20-kill-heal.opy"
#!include "30-kill-reset-cooldown.opy"
rule "[Tracer]: Recall follow Sombra":
    @Event eachPlayer
    @Team 1
    @Hero tracer
    @Condition eventPlayer.reset_pvar[4] != null
    @Condition eventPlayer.reset_pvar[4].reset_pvar[9] != null
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isFiringSecondaryFire() == false
    @Condition eventPlayer.isFiringPrimaryFire() == false
    @Condition eventPlayer.reset_pvar[4].isAlive() == true
    @Condition eventPlayer.reset_pvar[4].reset_pvar[9][0].isAlive() == true
    @Condition (not eventPlayer.isOnObjective() or not eventPlayer.isInSpawnRoom()) == true
    @Condition distance(eventPlayer.reset_pvar[4], eventPlayer.reset_pvar[4].reset_pvar[9][0]) <= 5.5
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    
    wait(0.8, Wait.ABORT_WHEN_FALSE)
    eventPlayer.startForcingButton(Button.ABILITY_2)
    waitUntil(not eventPlayer.isUsingAbility2(), 0.91)
    eventPlayer.teleport(nearestWalkablePosition(eventPlayer.reset_pvar[4][0] - worldVector(vect(0, 0, -5), eventPlayer, Transform.ROTATION)))
    eventPlayer.startFacing(vectorTowards(updateEveryFrame(eventPlayer.getEyePosition()), ((sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer.getEyePosition(), player.getEyePosition()) == true], lambda i: distance(eventPlayer.getEyePosition(), i.getEyePosition())))[0]).getEyePosition()), 10000)
    waitUntil(not eventPlayer.reset_pvar[4].reset_pvar[9][0].isAlive(), 3)
    eventPlayer.stopFacing()
