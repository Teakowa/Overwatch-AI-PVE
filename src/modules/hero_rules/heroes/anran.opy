rule "[Anran]: burning target damage amp":
    @Event playerDealtDamage
    @Hero anran
    @Condition victim.hasStatus(Status.BURNING) == true
    @Condition eventDamage > 0
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ABILITY_2, Button.MELEE, Button.ULTIMATE]
    @Condition eventPlayer.anran_burn_target != victim

    if eventPlayer.anran_burn_dmg_mod != null:
        stopDamageModification(eventPlayer.anran_burn_dmg_mod)
    startDamageModification(victim, attacker, 125, DamageReeval.RECEIVERS_AND_DAMAGERS)
    eventPlayer.anran_burn_dmg_mod = getLastDamageModification()
    eventPlayer.anran_burn_target = victim
    waitUntil(victim.isDead() or not victim.hasStatus(Status.BURNING) or eventPlayer.isDead() or eventPlayer.getHero() != Hero.ANRAN, WAIT_TIMEOUT_FOREVER)
    if eventPlayer.anran_burn_target == victim and eventPlayer.anran_burn_dmg_mod != null:
        stopDamageModification(eventPlayer.anran_burn_dmg_mod)
        eventPlayer.anran_burn_dmg_mod = null
        eventPlayer.anran_burn_target = null
