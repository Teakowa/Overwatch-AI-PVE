#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Sierra]: ability 1 heal":
    @Event eachPlayer
    @Hero sierra
    @Condition eventPlayer.isUsingAbility1() == true

    heal(eventPlayer, eventPlayer, SierraBuff[0])
    wait(0.5)
    if ruleCondition:
        loop()
