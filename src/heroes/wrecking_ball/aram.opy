rule "[Wrecking Ball] Grappling Claw cd reset":
    @Event eachPlayer
    @Hero wreckingBall
    @Condition eventPlayer.isInSpawnRoom() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) != 0

    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)

rule "[Wrecking Ball] Disable Adaptive Shield for allies":
    @Event eachPlayer
    @Hero wreckingBall
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingAbility2() == true
    @Disabled

    eventPlayer.disallowButton(Button.ABILITY_2)
    waitUntil(not eventPlayer.isUsingAbility2() or eventPlayer.reset_pvar[0] != false, 7)
    eventPlayer.allowButton(Button.ABILITY_2)
# wrecking ball aram-only piledriver reset

rule "[Wrecking Ball]: ctrl 0cd":
    @Event playerDealtKnockback
    @Hero wreckingBall
    @Condition eventAbility == Button.CROUCH

    victim.setStatusEffect(eventPlayer, Status.STUNNED, 0.3)
    eventPlayer.applyImpulse(Vector.UP, 15, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.setAbilityCooldown(Button.CROUCH, 0)
