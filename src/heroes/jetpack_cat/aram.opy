#!optimizeStrict

rule "[JetpackCat]: Frenetic Flight damage reduction":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.setDamageReceived(JETPACK_CAT_ARAM_ABILITY1_DAMAGE_RECEIVED)
    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    eventPlayer.setDamageReceived(100)
    wait(0.5)

rule "[JetpackCat]: Purr cleanses negative statuses":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.isUsingAbility2() == true

    resetStatuses()
    waitUntil(not eventPlayer.isUsingAbility2(), 3)

rule "[JetpackCat]: Catnapper damage reduction":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.setDamageReceived(JETPACK_CAT_ARAM_ULTIMATE_DAMAGE_RECEIVED)
    waitUntil(not eventPlayer.isUsingUltimate(), 6)
    wait(2)
    eventPlayer.setDamageReceived(100)

rule "[JetpackCat]: Catnapper bonus max health damage":
    @Event playerDealtKnockback
    @Hero jetpackCat
    @Condition eventAbility == Button.ULTIMATE
    @Condition victim.getTeam() != attacker.getTeam()
    @Condition (victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT)) == false

    damage(victim, attacker, victim.getMaxHealth() * JETPACK_CAT_ARAM_HEALTH_SCALAR)

rule "[JetpackCat]: Frenetic Flight fuel regeneration":
    @Event eachPlayer
    @Hero jetpackCat
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) != true
    @Condition eventPlayer.getAbilityResource(Button.SECONDARY_FIRE) < 100
    @Disabled

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

    victim.setStatusEffect(attacker, Status.STUNNED, JETPACK_CAT_ARAM_STUNNED_DURATION)
    heal(eventPlayer, eventPlayer, 25 + eventDamage)
