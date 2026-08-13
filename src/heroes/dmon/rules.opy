#!mainFile "../../main.opy"
#!optimizeStrict

rule "[D.Mon]: Plasma Saber proc":
    @Event playerDealtDamage
    @Hero dmon
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.isInAlternateForm() != true

    victim.setHealth(victim.getHealth() - victim.maxHealthPercent(DmonBuff[0]))
    heal(attacker, attacker, DmonBuff[1] + (victim.maxHealthPercent(DmonBuff[0]) * 0.5))
    wait(0.35)

rule "[D.Mon]: Fusion Repeater armor-special":
    @Event playerDealtDamage
    @Hero dmon
    @Condition eventAbility == Button.ABILITY_2
    @Condition eventPlayer.isInAlternateForm() != true
    @Condition victim.getHealthOfType(Health.ARMOR) > 0

    victim.setHealth(victim.getHealth() - (eventDamage * DmonBuff[5] / 100))

rule "[D.Mon]: Plasma Saber rush":
    @Event playerDealtKnockback
    @Hero dmon
    @Condition eventAbility == Button.PRIMARY_FIRE

    victim.setStatusEffect(attacker, Status.STUNNED, DmonBuff[3])

rule "[D.Mon]: shield rush speed":
    @Event eachPlayer
    @Hero dmon
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff - eventPlayer.mov_speed_penalty + DmonBuff[2])
    wait(0.16)
    waitUntil(not (eventPlayer.isFiringSecondaryFire() and eventPlayer.isUsingAbility1()), 12)
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff - eventPlayer.mov_speed_penalty)

rule "[D.Mon]: Limit Break knockdown":
    @Event playerDealtDamage
    @Hero dmon
    @Condition eventAbility == Button.ULTIMATE
    @Condition victim.unaffected != true

    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, DmonBuff[4])
    victim.applyImpulse(directionTowards(victim, attacker), 25, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
    victim.applyImpulse(Vector.UP, 8, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION)
