#!optimizeStrict

rule "[Soldier: 76]: Helix Rockets lose control":
    @Event playerDealtDamage
    @Hero soldier
    #@Condition attacker.getHero() == Hero.SOLDIER
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition attacker != victim

    #victim.applyImpulse(Vector.BACKWARD, 7, Relativity.TO_PLAYER)
    victim.setStatusEffect(attacker, Status.BURNING, S76Buff[0])
    victim.burn_stack += S76Buff[0]
    damage(victim, attacker, S76Buff[1])

rule "[Soldier: 76]: Helix Rockets burn dot":
    @Event playerDealtDamage
    @Hero soldier
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition attacker != victim

    wait(1)
    if S76Buff[0] <= 1:
        goto lbl_0
    damage(victim, attacker, S76Buff[1])
    wait(1)
    if S76Buff[0] <= 2:
        goto lbl_0
    damage(victim, attacker, S76Buff[1])
    lbl_0:
