#!optimizeStrict

rule "[Mizuki]: Substitute Doll clears negative statuses":
    @Event eachPlayer
    @Hero mizuki
    @Condition eventPlayer.isUsingAbility1() == true

	resetStatuses()
	eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 1.8)
	eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, 1.8)
	wait(1.8)
