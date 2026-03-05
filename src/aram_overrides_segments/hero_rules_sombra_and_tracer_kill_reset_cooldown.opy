rule "[Sombra]: kiil reset cooldown":
    @Event playerEarnedElimination
    @Hero sombra
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0
    
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    wait(0.5)

rule "[Tracer] Kill Heal":
    @Event playerEarnedElimination
    @Hero tracer
    @Condition Tracer_Ability[1] == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getHealth() < eventPlayer.getMaxHealth() == true
    
    heal(eventPlayer, null, 99999)

rule "[Tracer]: kiil reset cooldown":
    @Event playerEarnedElimination
    @Hero tracer
    @Condition Tracer_Ability[0] == true
    @Condition eventPlayer.isAlive() == true
    @Condition (eventPlayer.getAbilityCharge(Button.ABILITY_1) < 3 or eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0) == true
    
    eventPlayer.setAbilityCharge(Button.ABILITY_1, 3)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)

