#!include "grappling-claw-cd-reset.opy"
#!include "disable-adaptive-shield-for-allies.opy"
rule "[Wrecking Ball]: ctrl 0cd":
    @Event playerDealtKnockback
    @Hero wreckingBall
    @Condition eventAbility == Button.CROUCH
    
    victim.setStatusEffect(eventPlayer, Status.STUNNED, 0.3)
