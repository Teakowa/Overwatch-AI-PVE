#!optimizeStrict

rule "[Reinhardt] firestrike healing":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition (eventAbility == Button.ABILITY_2 or eventAbility == Button.ULTIMATE) == true

    if eventAbility == Button.ULTIMATE:
        goto lbl_0
    heal(eventPlayer, eventPlayer, eventDamage)
    lbl_0:
    victim.setStatusEffect(attacker, Status.BURNING, REINHARDT_ABILITY2_BURNING_DURATION)
    victim.burn_stack += 2
    damage(victim, attacker, 20)