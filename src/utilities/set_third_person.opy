def setThirdPerson():
    @Name "[utilities/Player]: Set Third Person"
    
    eventPlayer.startCamera(updateEveryFrame(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + worldVector(vect(1 * (min(-2.5 / 2.5, -0.75)), 0, 0), eventPlayer, Transform.ROTATION) + updateEveryFrame(eventPlayer.getFacingDirection() * -2.5), getAllPlayers(), eventPlayer, false).getHitPosition()), updateEveryFrame(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 200, getAllPlayers(), eventPlayer, false).getHitPosition()), 60)
    eventPlayer.startCamera(raycast(eventPlayer + (Vector.UP * (distance(eventPlayer.getEyePosition(), eventPlayer) + 0.5)), raycast(eventPlayer + (Vector.UP * (distance(eventPlayer.getEyePosition(), eventPlayer) + 1)), eventPlayer + (Vector.UP * (distance(eventPlayer.getEyePosition(), eventPlayer) + 0.8)) + eventPlayer.getFacingDirection() * -2, null, eventPlayer, true).getHitPosition(), null, eventPlayer, true).getHitPosition(), eventPlayer + eventPlayer.getFacingDirection() * 50, 100)
    waitUntil(eventPlayer.third_person != true, 999999986991104)
    eventPlayer.stopCamera()
