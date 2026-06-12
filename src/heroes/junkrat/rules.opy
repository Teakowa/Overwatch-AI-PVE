#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Junkrat]: arsonist":
    @Event playerDealtDamage
    @Hero junkrat
    #@Condition victim.hasStatus(Status.BURNING) == false
    @Condition eventAbility != Button.MELEE

    victim.setStatusEffect(attacker, Status.BURNING, JunkratBuff[0])
    if victim.hasStatus(Status.BURNING) != true:
        goto lbl_0
    damage(victim, attacker, victim.getHealth() * JunkratBuff[1])
    lbl_0:
    wait(1)
