#!optimizeStrict

rule "[Cassdy] Flashbang stun":
    @Event playerDealtDamage
    @Hero cassidy
    @Condition eventAbility == Button.ABILITY_2

    victim.setStatusEffect(attacker, Status.STUNNED, CASSIDY_ABILITY2_LINE_8_STUNNED_DURATION)
