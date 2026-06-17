#!mainFile "../main.opy"

#!optimizeStrict

def botAim2Target():
    @Name "[AI/global]: botAim2Target"

    if eventPlayer.getHero() in [Hero.FREJA, Hero.VENTURE, Hero.PHARAH, Hero.HAZARD, Hero.ANRAN] and eventPlayer.heroNum < len(ProjectileSpeed) and ProjectileSpeed[eventPlayer.heroNum] < 100000000 and (not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.getHero() == Hero.FREJA) and not eventPlayer.isUsingAbility1() and not eventPlayer.isUsingAbility2() and not eventPlayer.isUsingUltimate():
        eventPlayer.startFacing(directionTowards(eventPlayer + Vector.UP * distance(eventPlayer, eventPlayer.getEyePosition()) + worldVector(vect(0, 0, 0), eventPlayer, Transform.ROTATION), eventPlayer.botTarget.getEyePosition() + eventPlayer.botTarget.getVelocity() * distance(eventPlayer.getEyePosition(), eventPlayer.botTarget.getEyePosition()) / ProjectileSpeed[eventPlayer.heroNum]), 10000)
        return
    eventPlayer.startFacing(directionTowards(eventPlayer + Vector.UP * distance(eventPlayer, eventPlayer.getEyePosition()) + worldVector(vect(0, 0, 0), eventPlayer, Transform.ROTATION), eventPlayer.botTarget.getEyePosition()), 10000)
