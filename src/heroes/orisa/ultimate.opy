#!optimizeStrict

rule "[Orisa]: stun when ult":
    @Event playerDealtKnockback
    @Hero orisa
    @Condition eventAbility == Button.ULTIMATE
    @Condition victim.unaffected != true

    victim.setStatusEffect(attacker, Status.STUNNED, ORISA_ULTIMATE_LINE_9_STUNNED_DURATION)
