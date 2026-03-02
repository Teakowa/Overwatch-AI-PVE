rule "[Anran]: burning target damage amp":
    @Event eachPlayer
    @Hero anran
    @Condition eventPlayer.isDead() != true

    if eventPlayer.anran_burn_dmg_mod != null:
        stopDamageModification(eventPlayer.anran_burn_dmg_mod)
        eventPlayer.anran_burn_dmg_mod = null

    if len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.hasStatus(Status.BURNING) == true]) > 0:
        startDamageModification([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.hasStatus(Status.BURNING) == true], eventPlayer, 125, DamageReeval.RECEIVERS_AND_DAMAGERS)
        eventPlayer.anran_burn_dmg_mod = getLastDamageModification()

    wait(0.250)


rule "[Anran]: burning target damage amp cleanup":
    @Event eachPlayer
    @Condition eventPlayer.anran_burn_dmg_mod != null
    @Condition eventPlayer.isDead() == true or eventPlayer.getHero() != Hero.ANRAN

    stopDamageModification(eventPlayer.anran_burn_dmg_mod)
    eventPlayer.anran_burn_dmg_mod = null
