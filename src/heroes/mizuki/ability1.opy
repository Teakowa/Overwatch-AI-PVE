#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Mizuki]: Substitute Doll clears negative statuses":
    @Event eachPlayer
    @Hero mizuki
    @Condition eventPlayer.isUsingAbility1() == true

	resetStatuses()
	eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, MizukiBuff[0])
	eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, MizukiBuff[0])
	wait(1.8)
