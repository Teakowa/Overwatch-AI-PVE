rule "[Sombra] TP to Support":
    @Event eachPlayer
    @Team 1
    @Hero sombra
    @Condition eventPlayer.isUsingAbility1() == false
    @Condition eventPlayer.isFiringSecondaryFire() == false
    @Condition eventPlayer.isFiringPrimaryFire() == false
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) != 0
    @Condition (eventPlayer.reset_pvar[9][0].isAlive() and not eventPlayer.reset_pvar[9][0].isInSpawnRoom()) == true
    @Condition (not eventPlayer.isOnObjective() or not eventPlayer.isInSpawnRoom()) == true
    @Condition distance(eventPlayer, eventPlayer.reset_pvar[9][0]) >= 5.5
    @Condition distance(getClosestPlayer(eventPlayer, eventPlayer.getTeam()), eventPlayer.reset_pvar[9][0]) <= 30
    
    wait(2, Wait.ABORT_WHEN_FALSE)
    eventPlayer.teleport(nearestWalkablePosition(eventPlayer.reset_pvar[9][0] - worldVector(vect(0, 0, -7), eventPlayer, Transform.ROTATION)))
    eventPlayer.startFacing(vectorTowards(updateEveryFrame(eventPlayer.getEyePosition()), ((sorted([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer.getEyePosition(), player.getEyePosition()) == true], lambda i: distance(eventPlayer.getEyePosition(), i.getEyePosition())))[0]).getEyePosition()), 10000)
    waitUntil(not eventPlayer.reset_pvar[4].reset_pvar[9][0].isAlive(), 2)
    eventPlayer.stopFacing()
    wait(3)
rule "[Sombra]: AI Auto use Translocator":
    @Event eachPlayer
    @Team 1
    @Hero sombra
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition (eventPlayer.isAlive() and eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0) == true
    @Condition distance(eventPlayer, eventPlayer.reset_pvar[9][0]) >= 5.5
    @Condition distance(getClosestPlayer(eventPlayer, eventPlayer.getTeam()), eventPlayer.reset_pvar[9][0]) <= 30
    
    eventPlayer.forceButtonPress(Button.ABILITY_2)
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
#!include "kill-reset-cooldown.opy"
