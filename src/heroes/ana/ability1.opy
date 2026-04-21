rule "[Ana]: Sleep tanks for longer duration":
    @Event playerDealtDamage
    @Hero ana
    @Condition eventAbility == Button.ABILITY_1
    @Condition victim.unaffected == false

    victim.clearStatusEffect(Status.ASLEEP)
    #waitUntil(victim.hasStatus(Status.ASLEEP), Math.INFINITY)
    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 4)
