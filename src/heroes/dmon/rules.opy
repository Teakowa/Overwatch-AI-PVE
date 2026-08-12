#!mainFile "../../main.opy"
#!optimizeStrict

rule "[D.Mon]: Plasma Saber proc":
    @Event playerDealtDamage
    @Hero dmon
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.isInAlternateForm() != true

    damage(victim, attacker, victim.maxHealthPercent(DMON_PRIMARY_MAX_HEALTH_PERCENT))
    heal(attacker, attacker, DMON_PRIMARY_HEAL + (victim.maxHealthPercent(DMON_PRIMARY_MAX_HEALTH_PERCENT) * 0.5))
    wait(0.35)

rule "[D.Mon]: Plasma Saber rush":
    @Event playerDealtKnockback
    @Hero dmon
    @Condition eventAbility == Button.PRIMARY_FIRE
    
    victim.setStatusEffect(attacker, Status.STUNNED, 0.8)

rule "[D.Mon]: shield rush speed":
    @Event eachPlayer
    @Hero dmon
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff - eventPlayer.mov_speed_penalty + DMON_DASH_SPEED_PERCENT)
    wait(0.16)
    waitUntil(not (eventPlayer.isFiringSecondaryFire() and eventPlayer.isUsingAbility1()), 12)
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff - eventPlayer.mov_speed_penalty)

rule "[D.Mon]: Limit Break knockdown":
    @Event playerDealtDamage
    @Hero dmon
    @Condition eventAbility == Button.ULTIMATE
    @Condition victim.unaffected != true

    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, DMON_ULT_KNOCKDOWN_DURATION)
    victim.applyImpulse(directionTowards(victim, attacker), 25, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    victim.applyImpulse(Vector.UP, 8, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
