#!optimizeStrict

rule "[Sierra]: ability 1 heal":
    @Event eachPlayer
    @Hero sierra
    @Condition eventPlayer.isUsingAbility1() == true

    heal(eventPlayer, eventPlayer, SIERRA_ABILITY1_HEAL)
    wait(0.5)
    if ruleCondition:
        loop()
