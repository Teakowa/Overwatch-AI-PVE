#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Reinhardt] firestrike healing":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition (eventAbility == Button.ABILITY_2 or eventAbility == Button.ULTIMATE) == true

    if eventAbility == Button.ULTIMATE:
        goto lbl_0
    heal(eventPlayer, eventPlayer, eventDamage)
    lbl_0:
    victim.setStatusEffect(attacker, Status.BURNING, ReinhardtBuff[1])
    victim.burn_stack += 2
    damage(victim, attacker, 20)
