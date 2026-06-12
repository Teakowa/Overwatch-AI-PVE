#!mainFile "../../main.opy"
#!optimizeStrict

rule "[JetpackCat]: Purr cleanses negative statuses":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.isUsingAbility2() == true

    resetStatuses()
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, JetpackCatBuff[1])
    eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, JetpackCatBuff[1])
    wait(3)
