#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Emre]: Cyber Grenade Control + Burn":
    @Event playerDealtKnockback
    @Hero emre
    @Condition eventAbility == Button.ABILITY_2
    @Condition victim != eventPlayer
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    victim.setStatusEffect(attacker, Status.BURNING, EMRE_ABILITY2_BURNING_DURATION)
    damage(victim, attacker, 50)
	wait()
