#!optimizeStrict

rule "[Reinhardt] firestrike healing":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition (eventAbility == Button.ABILITY_2 or eventAbility == Button.ULTIMATE) == true

    if eventAbility == Button.ULTIMATE:
        goto lbl_0
    eventPlayer.startHealingOverTime(eventPlayer, 2, eventDamage * 2)
    lbl_0:
    victim.setStatusEffect(attacker, Status.BURNING, 2)
    victim.startDamageOverTime(attacker, 2, victim.getMaxHealth() * 0.05)

rule "[Reinhardt]: Earthshatter":
    @Event playerDealtFinalBlow
    @Hero reinhardt
    @Condition eventAbility == Button.ABILITY_1

    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    wait(1)

rule "[Reinhardt]: Earthshatter":
    @Event playerDealtFinalBlow
    @Hero reinhardt
    @Condition eventAbility == Button.ULTIMATE

    eventPlayer.setUltCharge(100)
    wait(0.5)

rule "[Reinhardt]: Crusaders stand":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.reinhardt_buff == false
    @Condition eventPlayer.getHealthOfType(Health.ARMOR) <= 0

    eventPlayer.reinhardt_buff = true
    wait(15)
    eventPlayer.reinhardt_buff = false
    smallMessage(eventPlayer, "  {0} 十字军坚定 已就绪".format(abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE)))

rule "[Reinhardt]: Crusaders stand":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.reinhardt_buff == true

    bigMessage(eventPlayer, "  十字军坚定")
    smallMessage(eventPlayer, "  {0} 无视击退".format(iconString(Icon.FLAG)))
    eventPlayer.addHealthPool(Health.NORMAL, 300, false, false)
    eventPlayer.setKnockbackReceived(0)
    waitUntil(not eventPlayer.reinhardt_buff, 8)
    eventPlayer.setKnockbackReceived(100)

rule "[Reinhardt]: Shield Slam knockback":
    @Event eachPlayer
    @Team 2
    @Hero reinhardt
    @Condition eventPlayer.isFiringSecondaryFire() == true

    eventPlayer.setKnockbackDealt(50)
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 99999)
    eventPlayer.setKnockbackDealt(100)

rule "[Reinhardt]: Shield Slam stun":
    @Event playerDealtKnockback
    @Hero reinhardt
    @Condition eventAbility == Button.SECONDARY_FIRE

    victim.setStatusEffect(attacker, Status.STUNNED, 1.2)

rule "[Reinhardt]: Attack to get overhealth":
    @Event playerDealtKnockback
    @Hero reinhardt
    @Condition eventAbility == Button.PRIMARY_FIRE
    @Condition attacker.getHero() == Hero.REINHARDT
    @Condition len(eventPlayer.rein_health_id) < 5

    eventPlayer.addHealthPool(Health.NORMAL, 50, false, false)
    eventPlayer.rein_health_id.append(getLastCreatedHealthPool())
    wait(0.5)
    #if ruleCondition:
    #        loop()

rule "[Reinhardt]: Attack to get overhealth removal":
    @Event eachPlayer
    @Hero reinhardt
    @Condition len(eventPlayer.rein_health_id) != 0

    wait(5, Wait.ABORT_WHEN_FALSE)
    removeHealthPool(eventPlayer.rein_health_id[0])
    eventPlayer.rein_health_id.remove(eventPlayer.rein_health_id[0])
    wait(0.25)
    if ruleCondition:
        loop()
    eventPlayer.rein_health_id = []

rule "[Rein]: fly":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()
