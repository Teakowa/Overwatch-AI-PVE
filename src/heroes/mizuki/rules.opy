#!optimizeStrict

rule "[Mizuki]: Soul Hat bonus heal and cooldown refund":
    @Event playerReceivedHealing
	@Condition healer.getHero() == Hero.MIZUKI
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition healee != healer

    heal(healee, healer, healee.getMaxHealth() * 0.10)
    healer.setAbilityCooldown(Button.SECONDARY_FIRE, max(0, healer.getAbilityCooldown(Button.SECONDARY_FIRE) - 0.5))
    wait(0.5)
#!include "ability1.opy"
#!include "ability2.opy"
