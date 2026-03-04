def botAim2Target():
    @Name "[AI/global]: botAim2Target"
    
    eventPlayer.startFacing(directionTowards(eventPlayer + Vector.UP * distance(eventPlayer, eventPlayer.getEyePosition()) + worldVector(vect(0, 0, 0), eventPlayer, Transform.ROTATION), eventPlayer.botTarget.getEyePosition()), 10000)

