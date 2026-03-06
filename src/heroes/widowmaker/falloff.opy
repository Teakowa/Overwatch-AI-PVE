rule "[widowmaker.opy]: Infra-Sight headshot x3":
    @Event playerDealtDamage
    @Hero widowmaker
    @Condition eventWasCriticalHit == true
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isFiringPrimaryFire() == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    damage(victim, attacker, (3 / 2.5 - 1) * eventDamage)


#!include "10-revert-sniper-damage-falloff.opy"

