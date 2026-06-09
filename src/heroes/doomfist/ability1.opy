#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Doomfist] Seismic Slam upper":
    @Event playerDealtDamage
    @Hero doomfist
    @Condition eventAbility == Button.ABILITY_1
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.unaffected != true
    @Condition (victim.getHero() == Hero.ORISA and (victim.isUsingAbility1() or victim.isUsingUltimate())) == false
    @Condition (victim.getHero() == Hero.MAUGA and victim.isUsingAbility1()) == false

    eventPlayer.doom_buff += 25
    eventPlayer.hudText = "{0}".format(floor(eventPlayer.doom_buff))
    victim.applyImpulse(Vector.UP, DOOMFIST_RULES_UPWARD_IMPULSE, Relativity.TO_PLAYER)
    victim.applyImpulse(worldVector(Vector.BACKWARD, attacker, Transform.ROTATION), DOOMFIST_RULES_BACKWARD_IMPULSE, Relativity.TO_WORLD)
    victim.startForcingThrottle(0, 0, 0, 0, 0, 0)
    waitUntil(victim.isOnGround() or victim.hasStatus(Status.PHASED_OUT), 1.2)
    victim.stopForcingThrottle()