#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Doomfist]: Meteor Strike":
    @Event eachPlayer
    @Hero doomfist
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.setDamageDealt(DOOMFIST_ULTIMATE_DAMAGE_DEALT_PERCENT_MAIN if eventPlayer.getTeam() == Team.1 else DOOMFIST_ULTIMATE_DAMAGE_DEALT_PERCENT_ALT)
    waitUntil(not eventPlayer.isUsingUltimate(), 10)
    eventPlayer.setDamageDealt(100)
