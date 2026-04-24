#!optimizeStrict

rule "[Wrecking Ball] Grappling Claw cd reset":
    @Event eachPlayer
    @Hero wreckingBall
    @Condition eventPlayer.isInSpawnRoom() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) != 0

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)

rule "[Wrecking Ball]: ctrl 0cd":
    @Event playerDealtKnockback
    @Hero wreckingBall
    @Condition eventAbility == Button.CROUCH

    victim.setStatusEffect(eventPlayer, Status.STUNNED, 0.3)
#!include "ability2.opy"
