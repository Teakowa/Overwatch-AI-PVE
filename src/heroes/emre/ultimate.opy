#!optimizeStrict

rule "[Emre]: Override Protocol Burn":
    @Event playerDealtDamage
    @Hero emre
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 0
    @Condition victim != eventPlayer
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.PHASED_OUT) or victim.has_nano) == false

    victim.setStatusEffect(attacker, Status.BURNING, EMRE_ULTIMATE_LINE_11_BURNING_DURATION)
    damage(victim, attacker, EMRE_ULTIMATE_LINE_12_BASE_DAMAGE + victim.getMaxHealth() * EMRE_ULTIMATE_LINE_12_HEALTH_SCALAR)
	wait()
