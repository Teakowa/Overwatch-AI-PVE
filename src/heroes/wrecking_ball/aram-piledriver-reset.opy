# wrecking ball aram-only piledriver reset

rule "[Wrecking Ball]: ctrl 0cd":
    @Event playerDealtKnockback
    @Hero wreckingBall
    @Condition eventAbility == Button.CROUCH
    
    victim.setStatusEffect(eventPlayer, Status.STUNNED, 0.3)
    eventPlayer.applyImpulse(Vector.UP, 15, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.setAbilityCooldown(Button.CROUCH, 0)
