rule "[Roadhog]: Breather":
    @Event eachPlayer
    @Team 1
    @Hero roadhog
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventAbility.getNormalizedHealth() != 1

    heal(getLivingPlayers(eventPlayer.getTeam()), eventPlayer, 70)
    wait(0.65)
    if ruleCondition:
        loop()

rule "[Roadhog]: Breather":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingAbility2() != true
    @Condition eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) <= 50

    wait(0.54)
    eventPlayer.setAbilityResource(Button.SECONDARY_FIRE, 50)
    wait(1.25)

rule "[Roadhog]: Breather":
    @Event eachPlayer
    @Hero roadhog
    @Condition eventPlayer.isUsingAbility2() == true

    eventPlayer.mov_speed_buff += 75
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff - eventPlayer.mov_speed_penalty)
    waitUntil(not eventPlayer.isUsingAbility2(), 15)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.mov_speed_buff = 0
