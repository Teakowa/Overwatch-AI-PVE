#!optimizeStrict

#!include "secondary.opy"

rule "[Wrecking Ball]: ctrl 0cd":
    @Event playerDealtKnockback
    @Hero wreckingBall
    @Condition eventAbility == Button.CROUCH

    victim.setStatusEffect(eventPlayer, Status.STUNNED, WRECKING_BALL_RULES_STUNNED_DURATION)
#!include "ability2.opy"
