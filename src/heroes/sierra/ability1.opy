#!optimizeStrict

rule "[Sierra]: ability 2 heal":
    @Event eachPlayer
    @Hero sierra
    @Condition eventPlayer.isUsingAbility1() == true

    heal(eventPlayer, eventPlayer, 25)
    wait(0.5)
    if ruleCondition:
        loop()
