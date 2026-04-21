rule "[Roadhog]: Breather":
    @Event eachPlayer
    @Team 1
    @Hero roadhog
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.getNormalizedHealth() < 1

    heal(getLivingPlayers(eventPlayer.getTeam()), eventPlayer, 70)
    wait(1)
    if ruleCondition:
        loop()


rule "[Roadhog]: Breather":
    @Event eachPlayer
    @Team 1
    @Hero roadhog
    @Condition eventPlayer.isUsingAbility2() != true
    @Condition eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) <= 50

    wait(0.54)
    eventPlayer.setAbilityResource(Button.SECONDARY_FIRE, 50)
    wait(1.25)
