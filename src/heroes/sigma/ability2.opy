#!optimizeStrict

rule "[Sigma]: Accretion knockdown":
    @Event playerDealtDamage
    @Hero sigma
    @Condition eventAbility == Button.ABILITY_2
    @Condition victim.hasStatus(Status.KNOCKED_DOWN) == true

    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 1.8)
