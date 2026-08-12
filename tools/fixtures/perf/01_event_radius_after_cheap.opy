#!mainFile "../../main.opy"
#!optimizeStrict

rule "[fixture]: damage event radius after cheap gates":
    @Event playerTookDamage
    @Team 1
    @Condition eventPlayer.isAlive() == true
    @Condition len(getPlayersInRadius(eventPlayer, 10, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES)) >= 3

    wait(1)
