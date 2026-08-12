#!mainFile "../../main.opy"
#!optimizeStrict

playervar dmon_dash_state
#!defineMember dmon_dash_active       dmon_dash_state[0]
#!defineMember dmon_dash_stun_applied dmon_dash_state[1]

rule "[D.Mon]: Plasma Saber proc":
    @Event playerDealtDamage
    @Hero dmon
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition eventPlayer.isUsingAbility2() != true
    @Condition eventPlayer.isInAlternateForm() != true
    @Condition eventPlayer.isUsingUltimate() != true

    damage(victim, attacker, victim.maxHealthPercent(DMON_PRIMARY_MAX_HEALTH_PERCENT))
    heal(attacker, attacker, DMON_PRIMARY_HEAL)
    if eventPlayer.dmon_dash_active == true:
        if eventPlayer.dmon_dash_stun_applied != true and victim.unaffected != true:
            victim.setStatusEffect(attacker, Status.STUNNED, DMON_DASH_STUN_DURATION)
            eventPlayer.dmon_dash_stun_applied = true
    wait()

rule "[D.Mon]: shield rush speed":
    @Event eachPlayer
    @Hero dmon
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.unaffected != true
    @Condition eventPlayer.dmon_dash_active != true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.dmon_dash_active = true
    eventPlayer.dmon_dash_stun_applied = false
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff - eventPlayer.mov_speed_penalty + DMON_DASH_SPEED_PERCENT)
    wait(0.16)
    waitUntil(not (eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true and eventPlayer.isUsingAbility1() == true), 1.5)
    eventPlayer.dmon_dash_active = false
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff - eventPlayer.mov_speed_penalty)

rule "[D.Mon]: Limit Break knockdown":
    @Event playerDealtDamage
    @Hero dmon
    @Condition eventAbility == Button.ULTIMATE
    @Condition victim.unaffected != true

    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, DMON_ULT_KNOCKDOWN_DURATION)
