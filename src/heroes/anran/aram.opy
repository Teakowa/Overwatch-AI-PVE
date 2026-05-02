#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.

#!optimizeStrict

rule "[Anran]: burning target damage amp":
    @Event eachPlayer
    @Hero anran
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true

    eventPlayer.anran_burn_target = getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())).filter(lambda player: player.hasStatus(Status.BURNING) == true)
    if not eventPlayer.anran_burn_target:
        if eventPlayer.anran_burn_dmg_mod != null:
            stopDamageModification(eventPlayer.anran_burn_dmg_mod)
            eventPlayer.anran_burn_dmg_mod = null
        eventPlayer.anran_burn_target = []
        wait(2)
        if ruleCondition:
            loop()
        goto lbl_0
    if eventPlayer.anran_burn_dmg_mod != null:
        stopDamageModification(eventPlayer.anran_burn_dmg_mod)
    startDamageModification(eventPlayer.anran_burn_target, eventPlayer, 300, DamageReeval.RECEIVERS_AND_DAMAGERS)
    eventPlayer.anran_burn_dmg_mod = getLastDamageModification()
    wait(2)
    if ruleCondition:
        loop()
    stopDamageModification(eventPlayer.anran_burn_dmg_mod)
    lbl_0:

rule "[Anran] heal from burning target":
    @Event playerDealtDamage
    @Hero anran
    @Condition eventAbility != 0
    @Condition victim.hasStatus(Status.BURNING) == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getNormalizedHealth() < 1

    damage(victim, attacker, victim.getMaxHealth() * 0.08)
    heal(eventPlayer, eventPlayer, 75 + len(eventPlayer.anran_burn_target) * 50)
    wait(1)

#!include "ability2.opy"