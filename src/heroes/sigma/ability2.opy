#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Sigma]: Accretion knockdown":
    @Event playerDealtKnockback
    @Hero sigma
    @Condition eventAbility == Button.ABILITY_2
    @Condition victim.hasStatus(Status.KNOCKED_DOWN) == true

    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, SIGMA_ABILITY2_KNOCKED_DOWN_DURATION)
