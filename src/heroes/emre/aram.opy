#!optimizeStrict

# emre aram-mode overlay (intentionally empty for Hero-First migration)

rule "[Emre][ARAM]: Cyber Grenade Control + Burn":
    @Event playerDealtKnockback
    @Hero emre
    @Condition eventAbility == Button.ABILITY_2
    @Condition victim != eventPlayer
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    victim.setStatusEffect(attacker, Status.BURNING, 2)
    damage(victim, attacker, 75 + victim.getMaxHealth() * 0.08)
	wait()

rule "[Emre][ARAM]: Override Protocol Burn":
    @Event playerDealtDamage
    @Hero emre
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 0
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    victim.setStatusEffect(attacker, Status.BURNING, 2)
    damage(victim, attacker, 125 + victim.getMaxHealth() * 0.20)
	wait()
