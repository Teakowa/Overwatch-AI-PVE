#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Bastion]: ability 1":
    @Event playerDealtKnockback
    @Hero bastion
    @Condition eventPlayer.isInAlternateForm() == true
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition victim != attacker
    
    damage(victim, attacker, victim.maxHealthPercent(12))
    victim.setStatusEffect(attacker, Status.BURNING, 1)
    wait()
