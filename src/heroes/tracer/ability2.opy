#!optimizeStrict

rule "[Tracer] Recall Healing":
    @Event eachPlayer
    @Hero tracer
    @Condition eventPlayer.isUsingAbility2() == true

    heal(eventPlayer, null, 50)

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
