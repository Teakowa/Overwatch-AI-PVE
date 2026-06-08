#!optimizeStrict

rule "[JetpackCat]: Catnapper damage reduction":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.setDamageReceived(JETPACK_CAT_ULTIMATE_DAMAGE_RECEIVED)
    waitUntil(not eventPlayer.isUsingUltimate(), 6)
    wait(2)
    eventPlayer.setDamageReceived(100)

rule "[JetpackCat]: Catnapper bonus max health damage":
    @Event playerDealtKnockback
    @Hero jetpackCat
    @Condition eventAbility == Button.ULTIMATE
    @Condition victim.getTeam() != attacker.getTeam()
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    damage(victim, attacker, victim.getMaxHealth() * JETPACK_CAT_ULTIMATE_HEALTH_SCALAR)
