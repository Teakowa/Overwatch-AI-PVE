#!optimizeStrict

rule "[Mizuki]: Soul Chain weakens target":
    @Event playerDealtDamage
    @Hero mizuki
    @Condition eventAbility == Button.ABILITY_2
    @Condition victim.getTeam() != attacker.getTeam()

	victim.setStatusEffect(attacker, Status.ROOTED, 2)
    victim.setDamageDealt(50)
    victim.setDamageReceived(145)
    victim.setHealingReceived(60)
    wait(4)
    if victim.isDead() != true:
    victim.setDamageDealt(100)
    victim.setDamageReceived(100)
    victim.setHealingReceived(100)
