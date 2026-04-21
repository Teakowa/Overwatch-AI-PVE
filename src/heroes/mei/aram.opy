# mei aram-only endothermic blaster

rule "[Mei]: Endothermic Blaster":

    @Event playerDealtDamage

    @Hero mei

    @Condition eventWasCriticalHit == true

    @Condition eventAbility == Button.SECONDARY_FIRE

    victim.setStatusEffect(attacker, Status.FROZEN, 0.75)

    wait(0.2)

# mei aram-only ice move

rule "[Mei]: Ice move":

    @Event eachPlayer

    @Hero mei

    @Condition eventPlayer.isUsingAbility1() == true

    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)

    wait()

    if ruleCondition:

        loop()
