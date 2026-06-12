#!optimizeStrict

rule "[Pharah]: kb effect":
    @Event playerDealtKnockback
    @Hero pharah
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition victim != eventPlayer

    damage(victim, attacker, ceil(victim.maxHealthPercent(PharahBuff[0])))
	wait()
