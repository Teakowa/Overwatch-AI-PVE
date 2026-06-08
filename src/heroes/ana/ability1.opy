#!optimizeStrict

rule "[Ana]: Sleep tanks for longer duration":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.unaffected == false

    victim.clearStatusEffect(Status.ASLEEP)
    #waitUntil(victim.hasStatus(Status.ASLEEP), Math.INFINITY)
    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, ANA_ABILITY1_LINE_11_KNOCKED_DOWN_DURATION)
