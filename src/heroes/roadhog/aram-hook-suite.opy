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
