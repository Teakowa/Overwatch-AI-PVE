# junkrat aram-only arsonist

rule "[Junkrat]: arsonist":
    @Event playerDealtDamage
    @Hero junkrat
    #@Condition victim.hasStatus(Status.BURNING) == false
    @Condition eventAbility != Button.MELEE
    
    victim.setStatusEffect(attacker, Status.BURNING, 3)
    if victim.hasStatus(Status.BURNING) != true:
        goto lbl_0
    damage(victim, attacker, victim.getHealth() * 0.1)
    lbl_0:
    wait(1)
