rule "[Tracer] Recall Healing":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.startHealingOverTime(null, 2, 25)
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
rule "[Sombra]: Apply OW1 hack on top of OW2 hack":
    @Event eachPlayer
    @Condition eventPlayer.hasStatus(Status.HACKED) == true
    @Condition eventPlayer.vendetta_hud != true
    
    stopChasingVariable(eventPlayer.hack_timer)
    eventPlayer.setStatusEffect(eventPlayer.reset_pvar[6], Status.HACKED, 4 if eventPlayer.getTeam() == Team.1 else 6)
    eventPlayer.hack_timer = 4 if eventPlayer.getTeam() == Team.1 else 6
    chaseAtRate(eventPlayer.hack_timer, 0, 1, ChaseRateReeval.NONE)
rule "[Sombra]: hack healing received":
    @Event eachPlayer
    @Condition eventPlayer.hasStatus(Status.HACKED) == true
    @Condition eventPlayer.mauga_berserker_soul != true
    
    eventPlayer.healing_decrease += SombraBuff[0]
    eventPlayer.setHealingReceived(100 - eventPlayer.healing_decrease + eventPlayer.healing_increase)
    #eventPlayer.sombra_buff = getLastCreatedEntity()
    waitUntil(not eventPlayer.hasStatus(Status.HACKED), 4 if eventPlayer.getTeam() == Team.1 else 6)
    eventPlayer.setHealingReceived(100)
    #destroyEffect(eventPlayer.sombra_buff)
    #eventPlayer.sombra_buff = null
    eventPlayer.healing_decrease = 0
rule "[Tracer] Kill Heal":
    @Event playerEarnedElimination
    @Hero tracer
    @Condition Tracer_Ability[1] == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getHealth() < eventPlayer.getMaxHealth() == true
    
    heal(eventPlayer, null, 99999)
rule "[Tracer]: kiil reset cooldown":
    @Event playerEarnedElimination
    @Hero tracer
    @Condition Tracer_Ability[0] == true
    @Condition eventPlayer.isAlive() == true
    @Condition (eventPlayer.getAbilityCharge(Button.ABILITY_1) < 3 or eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0) == true
    
    eventPlayer.setAbilityCharge(Button.ABILITY_1, 3)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
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
