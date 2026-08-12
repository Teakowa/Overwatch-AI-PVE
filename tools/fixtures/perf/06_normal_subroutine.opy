#!mainFile "../../main.opy"
#!optimizeStrict

def helper():
    @Name "[fixture]: helper()"

    eventPlayer.setHealth(100)

rule "[fixture]: normal synchronous subroutine use":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true

    helper()
