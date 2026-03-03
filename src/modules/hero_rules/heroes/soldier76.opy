rule "[Soldier: 76]: Helix Rockets lose control":
    @Event playerDealtDamage
    @Hero soldier
    #@Condition attacker.getHero() == Hero.SOLDIER
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition attacker != victim
    
    #victim.applyImpulse(Vector.BACKWARD, 7, Relativity.TO_PLAYER)
    victim.setStatusEffect(attacker, Status.BURNING, S76Buff[0])
    victim.startDamageOverTime(attacker, S76Buff[0], S76Buff[1])
