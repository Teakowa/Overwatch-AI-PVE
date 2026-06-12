#!mainFile "../../aramMain.opy"
#!optimizeStrict

# emre aram-mode overlay (intentionally empty for Hero-First migration)

rule "[Emre][ARAM]: Cyber Grenade Control + Burn":
    @Event playerDealtKnockback
    @Hero emre
    @Condition eventAbility == Button.ABILITY_2
    @Condition victim != eventPlayer
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    victim.setStatusEffect(attacker, Status.BURNING, EMRE_ARAM_ABILITY2_BURNING_DURATION)
    damage(victim, attacker, EMRE_ARAM_ABILITY2_BASE_DAMAGE + victim.maxHealthPercent(EmreBuff[0]))
	wait()

rule "[Emre][ARAM]: Override Protocol Burn":
    @Event playerDealtDamage
    @Hero emre
    @Condition eventAbility == Button.ULTIMATE
    @Condition eventDamage > 0
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    victim.setStatusEffect(attacker, Status.BURNING, EMRE_ARAM_ULTIMATE_BURNING_DURATION)
    damage(victim, attacker, EMRE_ARAM_ULTIMATE_BASE_DAMAGE + victim.maxHealthPercent(EmreBuff[1]))
	wait()
