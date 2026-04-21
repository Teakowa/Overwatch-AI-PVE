#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "[Sierra]: ability 2 stun":
    @Event playerDealtKnockback
    @Hero sierra
    @Condition eventAbility == Button.ABILITY_2
    
    victim.setStatusEffect(eventPlayer, Status.STUNNED, 0.75)
    damage(victim, attacker, 75 + victim.getMaxHealth() * 0.15)
    wait(1)

rule "[Sierra]: ultmate stun":
    @Event playerDealtKnockback
    @Hero sierra
    @Condition eventAbility == Button.ULTIMATE
    
    victim.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, 1.5)
    damage(victim, attacker, eventDamage / 2)
    wait(1.5)

rule "[Sierra]: ability 2 heal":
    @Event eachPlayer
    @Hero sierra
    @Condition eventPlayer.isUsingAbility1() == true
    
    heal(eventPlayer, eventPlayer, 25)
    wait(0.5)
    if ruleCondition:
        loop()


