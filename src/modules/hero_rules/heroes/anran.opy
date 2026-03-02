rule "[Anran]: Fiery Rush cooldown to 6s":
    @Event eachPlayer
    @Hero anran
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 6
    @Condition eventPlayer.isUsingAbility1() == true

    wait(0.016)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 6)


rule "[Anran]: Blaze Dance cooldown to 6s":
    @Event eachPlayer
    @Hero anran
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 6
    @Condition eventPlayer.isUsingAbility2() == true

    wait(0.016)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 6)


rule "[Anran]: bonus damage to burning targets":
    @Event playerDealtDamage
    @Hero anran
    @Condition victim.hasStatus(Status.BURNING) == true
    @Condition eventDamage > 0
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ABILITY_2, Button.MELEE, Button.ULTIMATE]

    damage(victim, attacker, ceil(eventDamage * 0.25))
