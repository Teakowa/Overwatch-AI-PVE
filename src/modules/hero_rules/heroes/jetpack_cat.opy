rule "[JetpackCat]: Frenetic Flight damage reduction":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.setDamageReceived(65)
    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    eventPlayer.setDamageReceived(100)
    if eventPlayer.getAbilityCooldown(Button.ABILITY_1) < 1:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 1)


rule "[JetpackCat]: Purr cleanses and enforces cooldown":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.isUsingAbility2() == true

    resetStatuses()
    waitUntil(not eventPlayer.isUsingAbility2(), 6)
    if eventPlayer.getAbilityCooldown(Button.ABILITY_2) < 6:
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, 6)


rule "[JetpackCat]: Catnapper damage reduction":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.setDamageReceived(25)
    waitUntil(not eventPlayer.isUsingUltimate(), 6)
    eventPlayer.setDamageReceived(100)


rule "[JetpackCat]: Catnapper bonus max health damage":
    @Event playerDealtKnockback
    @Hero jetpackCat
    @Condition eventAbility == Button.ULTIMATE
    @Condition victim.getTeam() != attacker.getTeam()
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    damage(victim, attacker, victim.getMaxHealth() * 0.5)


rule "[JetpackCat]: Frenetic Flight fuel regeneration":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) != true
    @Condition eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) < 100

    wait(0.1)
    eventPlayer.setAbilityResource(Button.SECONDARY_FIRE, min(100, eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) + 7.5))
    if ruleCondition:
        loop()


rule "[JetpackCat]: Claws Out melee stun":
    @Event playerDealtDamage
    @Hero jetpackCat
    @Condition eventAbility == Button.MELEE
    @Condition victim.getTeam() != attacker.getTeam()
    @Condition victim.unaffected != true
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    victim.setStatusEffect(attacker, Status.STUNNED, 0.5)
