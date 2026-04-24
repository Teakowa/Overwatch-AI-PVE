#!optimizeStrict

rule "[Reinhardt]: Charge cd":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility1() == true

    wait(0.592, Wait.ABORT_WHEN_FALSE)
    eventPlayer.reinhardt_charge_cd = 3
    chaseOverTime(eventPlayer.reinhardt_charge_cd, 0, 3, ChaseTimeReeval.NONE)
    waitUntil(not eventPlayer.isUsingAbility1() and eventPlayer.getAbilityCooldown(Button.ABILITY_1) >= 6, 3.592)
    if eventPlayer.reinhardt_charge_cd == 0:
        goto lbl_0
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) - eventPlayer.reinhardt_charge_cd)
    lbl_0:
