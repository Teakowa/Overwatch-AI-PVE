#!mainFile "../../aramMain.opy"
#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.

#!optimizeStrict

rule "[Burn]: stack while burning":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true

    if eventPlayer.hasStatus(Status.BURNING) != true:
        if eventPlayer.burn_stack != 0:
            eventPlayer.burn_stack = 0
        wait(1)
        if ruleCondition:
            loop()
        goto lbl_0
    eventPlayer.burn_stack += 2
    heal(eventPlayer.reset_pvar.first(), null, ceil(50 + eventPlayer.burn_stack * 2))
    wait(1)
    if ruleCondition:
        loop()
    lbl_0:

rule "[Anran]: burning target stack bonus":
    @Event playerDealtDamage
    @Hero anran
    @Condition eventAbility != 0
    @Condition eventDamage > 5
    @Condition victim.hasStatus(Status.BURNING) == true
    @Condition victim.burn_stack > 0
    @Condition eventPlayer.isAlive() == true

    damage(victim, attacker, ceil(75 + (victim.burn_stack * 2)))
    wait(1)

#!include "ability2.opy"
