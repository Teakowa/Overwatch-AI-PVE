rule "[Vendetta]: Soaring Slice":
    @Event eachPlayer
    @Hero vendetta
    @Condition eventPlayer.isUsingAbility2() == true

    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 2.5)
    eventPlayer.unaffected = true
    waitUntil(not true, eventPlayer.isUsingAbility2())
    wait(0.8)
    eventPlayer.unaffected = false
    eventPlayer.clearStatusEffect(Status.PHASED_OUT)

rule "[Vendetta]: Soaring Slice hack":
    @Event playerDealtKnockback
    @Hero vendetta
    @Condition eventAbility == Button.ABILITY_2
    #@Condition eventPlayer.mov_speed_buff == true

    victim.vendetta_hud = true
    stopChasingVariable(victim.hack_timer)
    victim.setStatusEffect(attacker, Status.HACKED, 1)
    victim.hack_timer = 1
    chaseAtRate(victim.hack_timer, 0, 1, ChaseRateReeval.NONE)
    wait(2)
    victim.vendetta_hud = false
