rule "[Roadhog]: Hogdrogen Exposure":
    @Event playerDealtHealing
    @Hero roadhog
    @Condition eventPlayer.isFiringSecondaryFire() == true
    @Condition eventAbility == Button.SECONDARY_FIRE

    heal(healee, healer, 50)
    wait(0.5)

rule "[Roadhog]: Breather":
    @Event eachPlayer
    @Team 1
    @Hero roadhog
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.getNormalizedHealth() < 1

    heal(getLivingPlayers(eventPlayer.getTeam()), eventPlayer, 70)
    wait(0.65)
    if ruleCondition:
        loop()

rule "[Roadhog]: Breather":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingAbility2() != true
    @Condition eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) <= 50

    wait(0.54)
    eventPlayer.setAbilityResource(Button.SECONDARY_FIRE, 50)
    wait(1.25)

rule "[Roadhog]: Breather":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingAbility2() == true

    eventPlayer.mov_speed_buff += 75
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff - eventPlayer.mov_speed_penalty)
    waitUntil(not eventPlayer.isUsingAbility2(), 15)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.mov_speed_buff = 0

rule "[Roadhog]: Chain Hook return cd":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility == Button.ABILITY_1

    waitUntil(not eventPlayer.isUsingAbility1(), 1.75)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) * 0.5)

rule "[Roadhog]: hook lancher":
    @Event playerDealtDamage
    @Hero roadhog
    @Condition eventAbility == Button.ABILITY_1

    smallMessage(eventPlayer, "  {0} 长按 {1} 发射敌人".format(abilityIconString(Hero.ROADHOG, Button.ABILITY_1), Button.INTERACT))
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    waitUntil(not eventPlayer.isUsingAbility1() or distance(attacker, victim) <= 1.5, 8)
    if eventPlayer.getTeam() == Team.1 or eventPlayer.isHoldingButton(Button.INTERACT) == true:
        eventPlayer.cancelPrimaryAction()
        lbl_0:
        victim.applyImpulse(attacker.getFacingDirection(), 85, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
