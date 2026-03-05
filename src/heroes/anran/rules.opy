rule "[Anran]: burning target damage amp":
    @Event eachPlayer
    @Condition eventPlayer.hasStatus(Status.BURNING) == true
    @Condition eventPlayer.anran_burn_dmg_mod == null
    @Condition len(getPlayersOnHero(Hero.ANRAN, getOppositeTeam(eventPlayer.getTeam()))) > 0

    startDamageModification(eventPlayer, getPlayersOnHero(Hero.ANRAN, getOppositeTeam(eventPlayer.getTeam())), ANRAN_BURN_TARGET_DAMAGE_AMP_PERCENT, DamageReeval.RECEIVERS_AND_DAMAGERS)
    eventPlayer.anran_burn_dmg_mod = getLastDamageModification()
    waitUntil(not eventPlayer.hasStatus(Status.BURNING) or eventPlayer.isDead() or isMatchBetweenRounds(), Math.INFINITY)
    wait(eventPlayer.getSlot() * 0.032)
    if eventPlayer.anran_burn_dmg_mod != null:
        stopDamageModification(eventPlayer.anran_burn_dmg_mod)
        eventPlayer.anran_burn_dmg_mod = null

rule "[Anran]: burning target damage amp cleanup":
    @Event eachPlayer
    @Condition eventPlayer.anran_burn_dmg_mod != null
    @Condition eventPlayer.isDead() == true or len(getPlayersOnHero(Hero.ANRAN, getOppositeTeam(eventPlayer.getTeam()))) == 0

    stopDamageModification(eventPlayer.anran_burn_dmg_mod)
    eventPlayer.anran_burn_dmg_mod = null
