#!mainFile "../../main.opy"
#!optimizeStrict

rule "[Mizuki]: Substitute Doll clears negative statuses":
    @Event eachPlayer
    @Hero mizuki
    @Condition eventPlayer.isUsingAbility1() == true

	resetStatuses()
	eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, MIZUKI_ABILITY1_INVINCIBLE_DURATION)
	eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, MIZUKI_ABILITY1_PHASED_OUT_DURATION)
	wait(1.8)
