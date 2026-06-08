#!optimizeStrict

rule "[Pharah]: kb effect":
    @Event playerDealtKnockback
    @Hero pharah
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition victim != eventPlayer

    damage(victim, attacker, ceil(percentOf(6, victim.getMaxHealth())))
	wait()
