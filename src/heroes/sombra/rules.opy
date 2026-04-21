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

rule "[Sombra]: kiil reset cooldown":
    @Event playerEarnedElimination
    @Hero sombra
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    wait(0.5)
#!include "ability1.opy"
