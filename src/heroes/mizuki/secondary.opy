#!mainFile "../../main.opy"

#!optimizeStrict

rule "[Mizuki]: Soul Hat bonus heal and cooldown refund":
    @Event playerReceivedHealing
	@Condition isHero(healer, Hero.MIZUKI)
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition healee != healer

    heal(healee, healer, healee.maxHealthPercent(MizukiBuff[2]))
    healer.setAbilityCooldown(Button.SECONDARY_FIRE, max(0, healer.getAbilityCooldown(Button.SECONDARY_FIRE) - 0.5))
    wait(0.5)
