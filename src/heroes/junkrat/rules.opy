#!optimizeStrict

rule "[Junkrat]: arsonist":
    @Event playerDealtDamage
    @Hero junkrat
    #@Condition victim.hasStatus(Status.BURNING) == false
    @Condition eventAbility != Button.MELEE

    victim.setStatusEffect(attacker, Status.BURNING, JUNKRAT_RULES_BURNING_DURATION)
    if victim.hasStatus(Status.BURNING) != true:
        goto lbl_0
    damage(victim, attacker, victim.getHealth() * JUNKRAT_RULES_HEALTH_SCALAR)
    lbl_0:
    wait(1)
