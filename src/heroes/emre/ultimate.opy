#!optimizeStrict

rule "[Emre]: Override Protocol Burn":
    @Event playerDealtDamage
    @Hero emre
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 0
    @Condition victim != eventPlayer
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.PHASED_OUT) or victim.has_nano) == false

    victim.setStatusEffect(attacker, Status.BURNING, EMRE_ULTIMATE_BURNING_DURATION)
    damage(victim, attacker, EMRE_ULTIMATE_BASE_DAMAGE + victim.getMaxHealth().scaledBy(EMRE_ULTIMATE_HEALTH_SCALAR))
	wait()
