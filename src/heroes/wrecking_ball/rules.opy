#!include "shared/10-grappling-claw-cd-reset.opy"
#!include "shared/20-disable-adaptive-shield-for-allies.opy"
rule "[Wrecking Ball]: ctrl 0cd":
    @Event playerDealtKnockback
    @Hero wreckingBall
    @Condition eventAbility == Button.CROUCH
    
    victim.setStatusEffect(eventPlayer, Status.STUNNED, 0.3)
