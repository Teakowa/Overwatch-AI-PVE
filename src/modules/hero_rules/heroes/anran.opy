rule "[Anran]: bonus damage to burning targets":
    @Event playerDealtDamage
    @Hero anran
    @Condition victim.hasStatus(Status.BURNING) == true
    @Condition eventDamage > 0
    @Condition eventAbility in [Button.PRIMARY_FIRE, Button.SECONDARY_FIRE, Button.ABILITY_1, Button.ABILITY_2, Button.MELEE, Button.ULTIMATE]

    damage(victim, attacker, ceil(eventDamage * 0.25))
