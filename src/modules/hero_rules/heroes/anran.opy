rule "[Anran]: burning target damage amp":
    @Event playerDealtDamage
    @Hero anran
    @Condition victim.hasStatus(Status.BURNING) == true
    @Condition eventDamage > 0
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ABILITY_2, Button.MELEE, Button.ULTIMATE]

    if eventPlayer.anran_burn_dmg_mod == null:
        eventPlayer.anran_burn_dmg_mod = []
    if len([entry for entry in eventPlayer.anran_burn_dmg_mod if entry[0] == victim]) != 0:
        goto lbl_0
    startDamageModification(victim, attacker, 125, DamageReeval.RECEIVERS_AND_DAMAGERS)
    eventPlayer.anran_burn_dmg_mod.append([victim, getLastDamageModification()])
    waitUntil(victim.isDead() or not victim.hasStatus(Status.BURNING) or eventPlayer.isDead() or eventPlayer.getHero() != Hero.ANRAN, WAIT_TIMEOUT_FOREVER)
    if len([entry for entry in eventPlayer.anran_burn_dmg_mod if entry[0] == victim]) != 0:
        stopDamageModification(([entry for entry in eventPlayer.anran_burn_dmg_mod if entry[0] == victim])[0][1])
        eventPlayer.anran_burn_dmg_mod.remove(([entry for entry in eventPlayer.anran_burn_dmg_mod if entry[0] == victim])[0])
    lbl_0:
