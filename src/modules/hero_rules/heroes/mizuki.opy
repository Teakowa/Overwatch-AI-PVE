rule "[Mizuki]: Soul Hat bonus heal and cooldown refund":
    @Event playerDealtHealing
    @Hero mizuki
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition healee != healer

    heal(healee, healer, healee.getMaxHealth() * 0.25)
    healer.setAbilityCooldown(Button.SECONDARY_FIRE, max(0, healer.getAbilityCooldown(Button.SECONDARY_FIRE) - 0.5))


rule "[Mizuki]: Substitute Doll clears negative statuses":
    @Event eachPlayer
    @Hero mizuki
    @Condition eventPlayer.isUsingAbility1() == true

    resetStatuses()


rule "[Mizuki]: Soul Chain weakens target":
    @Event playerDealtDamage
    @Hero mizuki
    @Condition eventAbility == Button.ABILITY_2
    @Condition victim.getTeam() != attacker.getTeam()

    victim.setDamageDealt(50)
    victim.mov_speed_buff -= 40
    victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
    wait(2)
    if victim.isDead() != true:
        victim.mov_speed_buff += 40
        victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
    victim.setDamageDealt(100)
