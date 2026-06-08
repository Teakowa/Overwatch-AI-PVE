#!optimizeStrict

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
    damage(eventPlayer, attacker, eventDamage * ZENYATTA_RULES_LINE_22_EVENT_DAMAGE_SCALAR)
    eventPlayer.isKnocked = true

#!include "melee.opy"

rule "[Zenyatta] Snap Kick (Self Wall)":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isMeleeing() == Button.MELEE
    @Condition eventPlayer.getVerticalFacingAngle() < 45

    if distance(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2.51, getAllPlayers(), eventPlayer, true).getHitPosition(), eventPlayer.getEyePosition()) <= 2.5:
        if raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 5, getAllPlayers(), eventPlayer, true).getPlayerHit() == null:
            eventPlayer.KnockbackDirection = eventPlayer.getFacingDirection() * -1
            Knockback()
#!include "ultimate.opy"
