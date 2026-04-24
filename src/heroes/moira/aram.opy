#!optimizeStrict

# moira aram-only fade disable on coalescence

rule "[Moira]: Fade disable on Coalescence":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingUltimate() == true
    @Disabled

    eventPlayer.setAbility1Enabled(false)
    eventPlayer.disallowButton(Button.ABILITY_1)
    waitUntil(not eventPlayer.isUsingUltimate(), 9)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.setAbility1Enabled(true)

rule "[Moira]: kill enemy":
    @Event playerEarnedElimination
    @Hero moira
    @Condition victim.moira_buff != true

    victim.moira_buff = true
    eventPlayer.hudText = "{0} / 6".format(len([player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.moira_buff == true]))

rule "[Moira]: kill enemy":
    @Event playerDealtFinalBlow
    @Hero moira
    @Condition victim.moira_buff != true

    victim.moira_buff = true
    eventPlayer.hudText = "{0} / 6".format(len([player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.moira_buff == true]))

rule "[Moira]: auto charge Coalescence":
    @Event eachPlayer
    @Hero moira
    @Condition len([player for player in getPlayers(getOppositeTeam(eventPlayer.getTeam())) if player.moira_buff == true]) >= 6
    @Condition eventPlayer.getUltCharge() != 100

    eventPlayer.setUltCharge(100)
    wait(15)
    if ruleCondition:
        loop()
