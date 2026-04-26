#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.

#!optimizeStrict

rule "[Anran]: burning target damage amp":
    @Event eachPlayer
    @Hero anran
    @Condition getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).filter(lambda player: player.hasStatus(Status.BURNING) == true) == true

    if eventPlayer.anran_burn_dmg_mod != null:
        stopDamageModification(eventPlayer.anran_burn_dmg_mod)
    startDamageModification(getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).filter(lambda player: player.hasStatus(Status.BURNING)), eventPlayer, 150, DamageReeval.RECEIVERS_AND_DAMAGERS)
    eventPlayer.anran_burn_dmg_mod = getLastDamageModification()
    wait(3)
    if ruleCondition:
        loop()
    stopDamageModification(eventPlayer.anran_burn_dmg_mod)

rule "[Anran] heal from burning target":
    @Event playerDealtDamage
    @Hero anran
    @Condition eventAbility != 0
    @Condition victim.hasStatus(Status.BURNING) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getNormalizedHealth() < 1

    heal(eventPlayer, eventPlayer, 25 + eventDamage * 0.65)
    wait(0.5)
