#!optimizeStrict

rule "[Mizuki]: Soul Chain weakens target":
    @Event playerDealtDamage
    @Hero mizuki
    @Condition eventAbility == Button.ABILITY_2
    @Condition victim.getTeam() != attacker.getTeam()

	victim.setStatusEffect(attacker, Status.ROOTED, MIZUKI_ABILITY2_LINE_9_ROOTED_DURATION)
    victim.setDamageDealt(MIZUKI_ABILITY2_LINE_10_DAMAGE_DEALT)
    victim.setDamageReceived(MIZUKI_ABILITY2_LINE_11_DAMAGE_RECEIVED)
    victim.setHealingReceived(MIZUKI_ABILITY2_LINE_12_HEALING_RECEIVED)
    wait(4)
    if victim.isDead() != true:
    victim.setDamageDealt(100)
    victim.setDamageReceived(100)
    victim.setHealingReceived(100)
