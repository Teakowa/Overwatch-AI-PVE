#!mainFile "../../../main.opy"
#!optimizeStrict

rule "[AI/control]: Domina Primary":
    @Event eachPlayer
    @Team 1
    @Hero domina
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.domina_ai_busy != true
    @Condition (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire() or eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2() or eventPlayer.isUsingUltimate()) != true
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true
    @Condition distance(eventPlayer, eventPlayer.botTarget) <= 25

    if eventPlayer.domina_ai_busy != true and (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire() or eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2() or eventPlayer.isUsingUltimate()) != true:
        eventPlayer.domina_ai_busy = true
        wait(0.032)
        if eventPlayer.domina_ai_busy == true and eventPlayer.isDummy() != false and eventPlayer.hasSpawned() == true and isHero(eventPlayer, Hero.DOMINA) and eventPlayer.isAlive() == true and eventPlayer.botTarget != null and eventPlayer.botTarget.isAlive() == true and isInLoS(eventPlayer, eventPlayer.botTarget) == true and distance(eventPlayer, eventPlayer.botTarget) <= 25 and (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire() or eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2() or eventPlayer.isUsingUltimate()) != true:
            eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
            wait(1.2)
            eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
        eventPlayer.domina_ai_busy = false
        wait(WAIT_AI_THROTTLE_MIN)

rule "[AI/control]: Domina Secondary":
    @Event playerTookDamage
    @Team 1
    @Hero domina
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.domina_ai_busy != true
    @Condition eventPlayer.domina_secondary_retry_blocked != true
    @Condition (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire() or eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2() or eventPlayer.isUsingUltimate()) != true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true

    if eventPlayer.domina_ai_busy != true and eventPlayer.domina_secondary_retry_blocked != true and eventPlayer.isDummy() != false and eventPlayer.hasSpawned() == true and isHero(eventPlayer, Hero.DOMINA) and eventPlayer.isAlive() == true and (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire() or eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2() or eventPlayer.isUsingUltimate()) != true and eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0 and eventPlayer.botTarget != null and eventPlayer.botTarget.isAlive() == true and isInLoS(eventPlayer, eventPlayer.botTarget) == true:
        eventPlayer.domina_ai_busy = true
        eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
        wait(WAIT_AI_THROTTLE_MIN)
        eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
        wait(0.032)
        if eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0:
            eventPlayer.domina_secondary_retry_blocked = true
        eventPlayer.domina_ai_busy = false
        if eventPlayer.domina_secondary_retry_blocked == true:
            wait(0.5)
            eventPlayer.domina_secondary_retry_blocked = false

rule "[AI/control]: Domina Ability 1":
    @Event eachPlayer
    @Team 1
    @Hero domina
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.domina_ai_busy != true
    @Condition (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire() or eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2() or eventPlayer.isUsingUltimate()) != true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true

    waitUntil(
        eventPlayer.botTarget != null and eventPlayer.botTarget.isAlive() == true and distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 16,
        random.uniform(0.65, 1.2)
    )
    if eventPlayer.domina_ai_busy != true and eventPlayer.isDummy() != false and eventPlayer.hasSpawned() == true and isHero(eventPlayer, Hero.DOMINA) and eventPlayer.isAlive() == true and eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0 and eventPlayer.botTarget != null and eventPlayer.botTarget.isAlive() == true and isInLoS(eventPlayer, eventPlayer.botTarget) == true and distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) < 16 and (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire() or eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2() or eventPlayer.isUsingUltimate()) != true:
        eventPlayer.domina_ai_busy = true
        eventPlayer.startForcingButton(Button.ABILITY_1)
        wait(WAIT_AI_THROTTLE_MIN)
        eventPlayer.stopForcingButton(Button.ABILITY_1)
        eventPlayer.domina_ai_busy = false

rule "[AI/control]: Domina Ability 2":
    @Event eachPlayer
    @Team 1
    @Hero domina
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.domina_ai_busy != true
    @Condition (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire() or eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2() or eventPlayer.isUsingUltimate()) != true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true
    @Condition distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) <= 14

    if eventPlayer.domina_ai_busy != true and eventPlayer.isDummy() != false and eventPlayer.hasSpawned() == true and isHero(eventPlayer, Hero.DOMINA) and eventPlayer.isAlive() == true and (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire() or eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2() or eventPlayer.isUsingUltimate()) != true and eventPlayer.getAbilityCooldown(Button.ABILITY_2) == 0 and eventPlayer.botTarget != null and eventPlayer.botTarget.isAlive() == true and isInLoS(eventPlayer, eventPlayer.botTarget) == true and distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) <= 14:
        eventPlayer.domina_ai_busy = true
        eventPlayer.startForcingButton(Button.ABILITY_2)
        wait(WAIT_AI_THROTTLE_MIN)
        eventPlayer.stopForcingButton(Button.ABILITY_2)
        eventPlayer.domina_ai_busy = false

rule "[AI/control]: Domina Ultimate":
    @Event eachPlayer
    @Team 1
    @Hero domina
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.domina_ai_busy != true
    @Condition (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire() or eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2() or eventPlayer.isUsingUltimate()) != true
    @Condition eventPlayer.getUltCharge() == 100
    @Condition eventPlayer.botTarget != null
    @Condition eventPlayer.botTarget.isAlive() == true
    @Condition isInLoS(eventPlayer, eventPlayer.botTarget) == true
    @Condition eventPlayer.botTarget.getNormalizedHealth() <= 0.45

    waitUntil(
        eventPlayer.botTarget != null and eventPlayer.botTarget.isAlive() == true and distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) <= 16,
        4
    )
    if eventPlayer.domina_ai_busy != true and eventPlayer.isDummy() != false and eventPlayer.hasSpawned() == true and isHero(eventPlayer, Hero.DOMINA) and eventPlayer.isAlive() == true and eventPlayer.getUltCharge() == 100 and eventPlayer.botTarget != null and eventPlayer.botTarget.isAlive() == true and isInLoS(eventPlayer, eventPlayer.botTarget) == true and distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.botTarget.getPosition() * vect(1, 0, 1)) <= 16 and eventPlayer.botTarget.getNormalizedHealth() <= 0.45 and (eventPlayer.isFiringPrimaryFire() or eventPlayer.isFiringSecondaryFire() or eventPlayer.isUsingAbility1() or eventPlayer.isUsingAbility2() or eventPlayer.isUsingUltimate()) != true:
        eventPlayer.domina_ai_busy = true
        eventPlayer.forceButtonPress(Button.ULTIMATE)
        wait(WAIT_AI_THROTTLE_MIN)
        eventPlayer.domina_ai_busy = false
