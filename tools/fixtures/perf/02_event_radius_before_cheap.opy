#!mainFile "../../main.opy"
#!optimizeStrict

rule "[fixture]: damage event radius before cheap gates":
    @Event playerTookDamage
    @Team 1
    @Condition len(getPlayersInRadius(eventPlayer, 10, getOppositeTeam(eventPlayer.getTeam()), LosCheck.SURFACES)) >= 3
    @Condition eventPlayer.isAlive() == true

    wait(1)
