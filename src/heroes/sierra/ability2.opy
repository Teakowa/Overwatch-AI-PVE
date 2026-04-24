#!optimizeStrict

rule "[Sierra]: ability 2 stun":
    @Event playerDealtKnockback
    @Hero sierra
    @Condition eventAbility == Button.ABILITY_2

    victim.setStatusEffect(eventPlayer, Status.STUNNED, 0.75)
    damage(victim, attacker, 75 + victim.getMaxHealth() * 0.15)
    wait(1)
