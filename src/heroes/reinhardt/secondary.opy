#!optimizeStrict

rule "[Reinhardt]: Shield Slam knockback":
    @Event eachPlayer
    @Team 2
    @Hero reinhardt
    @Condition eventPlayer.isFiringSecondaryFire() == true

    eventPlayer.setKnockbackDealt(REINHARDT_SECONDARY_KNOCKBACK_DEALT)
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 99999)
    eventPlayer.setKnockbackDealt(100)

rule "[Reinhardt]: Shield Slam stun":
    @Event playerDealtKnockback
    @Hero reinhardt
    @Condition eventAbility == Button.SECONDARY_FIRE

    victim.setStatusEffect(attacker, Status.STUNNED, REINHARDT_SECONDARY_STUNNED_DURATION)