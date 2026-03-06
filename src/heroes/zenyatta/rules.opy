rule "[Zenyatta]: headshot damage":
    @Event playerDealtDamage
    @Hero zenyatta
    @Condition HeadshotDamage[0] > 2
    @Condition eventWasCriticalHit == true
    @Condition eventAbility != Button.ABILITY_1
    @Condition eventAbility != Button.ABILITY_2
    @Condition eventAbility != Button.ULTIMATE
    
    damage(victim, attacker, ceil((eventDamage * (HeadshotDamage[0] - 2)) / 2))
rule "[Zenyatta] Snap Kick (enemy)":
    @Event playerTookDamage
    @Condition eventAbility == Button.MELEE
    @Condition attacker.getHero() == Hero.ZENYATTA == true
    
    eventPlayer.KnockbackDirection = directionFromAngles(attacker.getHorizontalFacingAngle(), -10)
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0.5)
    Knockback()
    damage(eventPlayer, attacker, eventDamage * 0.5)
    eventPlayer.isKnocked = true
#!include "shared/10-snap-kick-self.opy"
rule "[Zenyatta]: Transcendence":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isUsingUltimate() == true
    
    if abs(eventPlayer.mov_speed_buff) < abs(25):
        eventPlayer.mov_speed_buff = 25
        applySignedMoveSpeed()
    wait(WAIT_SHORT_FRAME)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 6)
    eventPlayer.setHealingDealt(133.34)
    waitUntil(not eventPlayer.isUsingUltimate() or eventPlayer.isDead(), 6)
    if eventPlayer.isDead() != true:
        if eventPlayer.mov_speed_buff == 25:
            eventPlayer.mov_speed_buff = 0
            applySignedMoveSpeed()
    eventPlayer.setHealingDealt(100)
