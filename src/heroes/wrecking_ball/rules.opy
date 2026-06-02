#!optimizeStrict

#!include "secondary.opy"

rule "[Wrecking Ball]: ctrl 0cd":
    @Event playerDealtKnockback
    @Hero wreckingBall
    @Condition eventAbility == Button.CROUCH

    victim.setStatusEffect(eventPlayer, Status.STUNNED, 0.3)
#!include "ability2.opy"
