#!mainFile "../../../main.opy"
#!optimizeStrict

# D.Mon Custom AI control: effect-driven close-range tank.
#
# All PvE effects (Plasma Saber true damage / self-heal, Fusion Repeater
# armor-special, Shield Rush speed + stun, Limit Break knockdown) stay in
# src/heroes/dmon/rules.opy. This module only operates the buttons so the
# native + custom effects fire as often and as deliberately as possible.
#
# Distances consume the cached botTargetDistance from the movement loop;
# no per-rule distance() / getPlayersInRadius() scans are added here.
#!define DMON_SABER_RANGE 6.5
#!define DMON_RUSH_MIN_RANGE 6
#!define DMON_RUSH_MAX_RANGE 15
#!define DMON_RUSH_MAX_TIME 3.5
#!define DMON_REPEATER_POKE_RANGE 12
#!define DMON_REPEATER_BURST 1.0
#!define DMON_BARRIER_HEALTH_THRESHOLD 0.55
#!define DMON_BARRIER_HOLD 0.8


rule "[AI/control]: D.Mon Pilot":
    @Event eachPlayer
    @Team 1
    @Hero dmon
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isInAlternateForm() == true
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true

    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.stopForcingButton(Button.ABILITY_1)
    eventPlayer.stopForcingButton(Button.ABILITY_2)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(0.5)
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "[AI/control]: D.Mon Re-mech":
    @Event eachPlayer
    @Team 1
    @Hero dmon
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isInAlternateForm() == true
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition eventPlayer.getUltCharge() == 100

    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.forceButtonPress(Button.ULTIMATE)
    wait(1)


rule "[AI/control]: D.Mon Shield Rush":
    @Event eachPlayer
    @Team 1
    @Hero dmon
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isInAlternateForm() != true
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition eventPlayer.isUsingAbility2() != true
    @Condition eventPlayer.isFiringSecondaryFire() != true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true
    @Condition eventPlayer.botTargetDistance != null and eventPlayer.botTargetDistance >= DMON_RUSH_MIN_RANGE and eventPlayer.botTargetDistance <= DMON_RUSH_MAX_RANGE

    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(WAIT_AI_THROTTLE_MIN)
    eventPlayer.startForcingButton(Button.ABILITY_1)
    waitUntil(not eventPlayer.isUsingAbility1(), DMON_RUSH_MAX_TIME)
    eventPlayer.stopForcingButton(Button.ABILITY_1)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)


rule "[AI/control]: D.Mon Plasma Saber":
    @Event eachPlayer
    @Team 1
    @Hero dmon
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isInAlternateForm() != true
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition eventPlayer.isUsingAbility1() != true
    @Condition eventPlayer.isFiringSecondaryFire() != true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true
    @Condition eventPlayer.botTargetDistance != null and eventPlayer.botTargetDistance <= DMON_SABER_RANGE

    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(0.5)
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)


rule "[AI/control]: D.Mon Fusion Repeater":
    @Event eachPlayer
    @Team 1
    @Hero dmon
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isInAlternateForm() != true
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition eventPlayer.isUsingAbility1() != true
    @Condition eventPlayer.isUsingAbility2() != true
    @Condition eventPlayer.isFiringSecondaryFire() != true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true
    @Condition eventPlayer.botTargetDistance != null and eventPlayer.botTargetDistance > DMON_SABER_RANGE
    @Condition (eventPlayer.botTarget.getHealthOfType(Health.ARMOR) > 0 or eventPlayer.botTargetDistance > DMON_REPEATER_POKE_RANGE) == true

    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(WAIT_AI_THROTTLE_MIN)
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(DMON_REPEATER_BURST)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    eventPlayer.forceButtonPress(Button.ABILITY_2)


rule "[AI/control]: D.Mon Power Barrier":
    @Event playerTookDamage
    @Team 1
    @Hero dmon
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isInAlternateForm() != true
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition eventPlayer.isUsingAbility1() != true
    @Condition eventPlayer.getNormalizedHealth() < DMON_BARRIER_HEALTH_THRESHOLD
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true

    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    wait(DMON_BARRIER_HOLD)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
