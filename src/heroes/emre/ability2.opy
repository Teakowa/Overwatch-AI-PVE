#!optimizeStrict

rule "[Emre]: Cyber Grenade Control + Burn":
    @Event playerDealtDamage
    @Hero emre
    @Condition eventAbility == Button.ABILITY_2
    @Condition victim != eventPlayer
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT) or victim.has_nano) == false

    victim.setStatusEffect(attacker, Status.BURNING, 2)
    damage(victim, attacker, 75 + victim.getMaxHealth() * 0.15)
	wait()
