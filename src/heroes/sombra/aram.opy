#!optimizeStrict

rule "[Sombra]: kiil reset cooldown":
    @Event playerEarnedElimination
    @Hero sombra
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    wait(0.5)
# sombra aram-only hack suite

rule "[Sombra]: Apply OW1 hack on top of OW2 hack":
    @Event eachPlayer
    @Condition eventPlayer.hasStatus(Status.HACKED) == true
    @Condition eventPlayer.vendetta_hud != true

    stopChasingVariable(eventPlayer.hack_timer)
    eventPlayer.setStatusEffect(eventPlayer.reset_pvar[6], Status.HACKED, 5)
    eventPlayer.hack_timer = 5
    chaseAtRate(eventPlayer.hack_timer, 0, 1, ChaseRateReeval.NONE)

rule "[Sombra]: hack healing received":
    @Event eachPlayer
    @Condition eventPlayer.hasStatus(Status.HACKED) == true

    eventPlayer.setHealingReceived(100 - SombraBuff[0])
    waitUntil(not eventPlayer.hasStatus(Status.HACKED), 5)
    eventPlayer.setHealingReceived(100)
