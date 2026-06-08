#!optimizeStrict

rule "[Soldier: 76]: Helix Rockets burn":
    @Event playerDealtDamage
    @Hero soldier
    #@Condition attacker.getHero() == Hero.SOLDIER
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition attacker != victim

    #victim.applyImpulse(Vector.BACKWARD, SOLDIER76_RULES_IMPULSE, Relativity.TO_PLAYER)
    victim.setStatusEffect(attacker, Status.BURNING, S76Buff[0])
    victim.burn_stack += S76Buff[0]
    damage(victim, attacker, S76Buff[1])
