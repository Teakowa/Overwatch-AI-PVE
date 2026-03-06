# mei aram-only endothermic blaster

rule "[Mei]: Endothermic Blaster":
    @Event playerDealtDamage
    @Hero mei
    @Condition eventWasCriticalHit == true
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    victim.setStatusEffect(attacker, Status.FROZEN, 0.75)
    wait(0.2)
