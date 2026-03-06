# widowmaker aram-mode overlay

rule "[widowmaker.opy]: Infra-Sight headshot":
    @Event playerDealtDamage
    @Hero widowmaker
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isFiringPrimaryFire() == true
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    if eventWasCriticalHit != true:
        goto lbl_0
    damage(victim, attacker, victim.getMaxHealth() * (0.9 if eventPlayer.isUsingUltimate() == true else 0.5))
    lbl_0:

#!include "10-revert-sniper-damage-falloff.opy"
