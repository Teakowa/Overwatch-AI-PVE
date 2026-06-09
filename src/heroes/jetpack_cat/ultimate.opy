#!mainFile "../../main.opy"
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
    @Condition victim.untargetable() != true

    damage(victim, attacker, victim.getMaxHealth().scaledBy(JETPACK_CAT_ULTIMATE_HEALTH_SCALAR))
