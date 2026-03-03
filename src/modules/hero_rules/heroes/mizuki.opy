rule "[Mizuki]: Soul Hat bonus heal and cooldown refund":
    @Event playerReceivedHealing
	@Condition healer.getHero() == Hero.MIZUKI
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition healee != healer

    heal(healee, healer, healee.getMaxHealth() * 0.10)
    healer.setAbilityCooldown(Button.SECONDARY_FIRE, max(0, healer.getAbilityCooldown(Button.SECONDARY_FIRE) - 0.5))

rule "[Mizuki]: Substitute Doll clears negative statuses":
    @Event eachPlayer
    @Hero mizuki
    @Condition eventPlayer.isUsingAbility1() == true

	resetStatuses()
	eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 1.8)
	eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, 1.8)
	wait(1.8)

rule "[Mizuki]: Soul Chain weakens target":
    @Event playerDealtDamage
    @Hero mizuki
    @Condition eventAbility == Button.ABILITY_2
    @Condition victim.getTeam() != attacker.getTeam()

	victim.setStatusEffect(attacker, Status.ROOTED, 2)
    victim.setDamageDealt(50)
    if abs(victim.mov_speed_buff) < 60:
        victim.mov_speed_buff = -60
        victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
    wait(4)
    if victim.isDead() != true:
        if victim.mov_speed_buff == -60:
            victim.mov_speed_buff = 0
            victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
    victim.setDamageDealt(100)
