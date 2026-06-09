#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Zenyatta] stop knocked":
    @Event eachPlayer
    @Condition eventPlayer.isKnocked == true

    wait(0.016, Wait.ABORT_WHEN_FALSE)
    eventPlayer.stopForcingThrottle()
    eventPlayer.isKnocked = false

rule "[Zenyatta] Snap Kick (Self Ground)":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isMeleeing() == Button.MELEE
    @Condition eventPlayer.getVerticalFacingAngle() >= 45

    if distance(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2.51, getAllPlayers(), eventPlayer, true).getHitPosition(), eventPlayer.getEyePosition()) <= 2.5:
        eventPlayer.KnockbackDirection = eventPlayer.getFacingDirection() * -1
        Knockback()
