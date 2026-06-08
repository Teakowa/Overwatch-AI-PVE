#!optimizeStrict

# emre aram-mode overlay (intentionally empty for Hero-First migration)

rule "[Emre][ARAM]: Cyber Grenade Control + Burn":
    @Event playerDealtKnockback
    @Hero emre
    @Condition eventAbility == Button.ABILITY_2
    @Condition victim != eventPlayer
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    victim.setStatusEffect(attacker, Status.BURNING, EMRE_ARAM_LINE_12_BURNING_DURATION)
    damage(victim, attacker, EMRE_ARAM_LINE_13_BASE_DAMAGE + victim.getMaxHealth() * EMRE_ARAM_LINE_13_HEALTH_SCALAR)
	wait()

rule "[Emre][ARAM]: Override Protocol Burn":
    @Event playerDealtDamage
    @Hero emre
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 0
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    victim.setStatusEffect(attacker, Status.BURNING, EMRE_ARAM_LINE_23_BURNING_DURATION)
    damage(victim, attacker, EMRE_ARAM_LINE_24_BASE_DAMAGE + victim.getMaxHealth() * EMRE_ARAM_LINE_24_HEALTH_SCALAR)
	wait()
