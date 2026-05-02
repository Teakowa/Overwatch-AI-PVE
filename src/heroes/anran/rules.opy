#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.

#!optimizeStrict

rule "[Anran]: burning target damage amp":
    @Event eachPlayer
    @Hero anran
    @Condition eventPlayer.hasSpawned() == true

    if eventPlayer.hasStatus(Status.BURNING) != true:
        if eventPlayer.anran_burn_stack != 0:
            eventPlayer.anran_burn_stack = 0
        wait(1)
        if ruleCondition:
            loop()
        goto lbl_0
    eventPlayer.anran_burn_stack += 1
    getPlayersOnHero(Hero.ANRAN, getOppositeTeam(eventPlayer.getTeam())).startHealingOverTime(eventPlayer, 1, ceil(eventPlayer.anran_burn_stack * ANRAN_BURN_STACK_HEAL_PER_SECOND * (0.75 if eventPlayer.getHero() in getTankHeroes() else 1)))
    wait(1)
    if ruleCondition:
        loop()
    lbl_0:

rule "[Anran]: burning target stack bonus":
    @Event playerDealtDamage
    @Hero anran
    @Condition eventAbility != 0
    @Condition victim.hasStatus(Status.BURNING) == true
    @Condition victim.anran_burn_stack > 0
    @Condition eventPlayer.isAlive() == true

    damage(victim, attacker, ceil(eventDamage * (((ANRAN_BURN_TARGET_DAMAGE_AMP_PERCENT - 100) / 100 + victim.anran_burn_stack * ANRAN_BURN_STACK_DAMAGE_PERCENT / 100) * (0.75 if victim.getHero() in getTankHeroes() else 1))))
    wait(0.5)

#!include "ability2.opy"
