#!optimizeStrict

rule "[Emre]: Cyber Grenade Control + Burn":
    @Event playerDealtKnockback
    @Hero emre
    @Condition eventAbility == Button.ABILITY_2
    @Condition victim != eventPlayer
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    victim.setStatusEffect(attacker, Status.BURNING, 2)
    damage(victim, attacker, 50)
	wait()
