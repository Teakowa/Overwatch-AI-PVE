rule "[Mauga]: Fortify provides 100 temporary armor":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.unaffected = true
    eventPlayer.hazard_buff[0] = false
    eventPlayer.brigitte_buff[0] = false
    eventPlayer.orisa_buff = false
    eventPlayer.zarya_graviton_buff[0] = false
    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    eventPlayer.unaffected = false

rule "[Mauga]: Cage Fight heal":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.mauga_berserker_soul != true
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition (len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer, player) <= 7 and player.hasStatus(Status.ROOTED)])) > 0

    eventPlayer.startHealingOverTime(eventPlayer, 2, 120 * (len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if distance(eventPlayer, player) <= 7 and player.hasStatus(Status.ROOTED)])))
    wait(1.996)
    if ruleCondition:
        loop()

rule "[Mauga]: Fortify provides 100 temporary armor":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.unaffected = true
    eventPlayer.hazard_buff[0] = false
    eventPlayer.brigitte_buff[0] = false
    eventPlayer.orisa_buff = false
    eventPlayer.zarya_graviton_buff[0] = false
    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    eventPlayer.unaffected = false

rule "[Mauga] Overrun knockdown duration":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.isUsingAbility1() == true

    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, 5)
    waitUntil(not eventPlayer.isUsingAbility1(), 5)
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)

rule "[Mauga] Overrun knockdown duration":
    @Event playerDealtDamage
    @Hero mauga
    @Condition eventAbility == Button.ABILITY_1

    victim.setStatusEffect(attacker, Status.BURNING, 2)
    if victim.hasStatus(Status.KNOCKED_DOWN):
        goto lbl_0
    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 0.5)
    lbl_0:
    if victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT) or victim.has_nano:
        goto lbl_1
    damage(victim, attacker, ceil(victim.getMaxHealth() * MaugaBuff[3]))
    lbl_1:

rule "[Mauga]: Berserker Soul status active":
    @Event playerTookDamage
    @Hero mauga
    #@Condition eventDamage > eventPlayer.getHealth() + 25
    @Condition eventPlayer.mauga_berserker_soul != true
    @Condition eventPlayer.getHealth() <= 250

    eventPlayer.mauga_berserker_soul = true
    bigMessage(eventPlayer, "狂战士之魂！")
    waitUntil(eventPlayer.isDead(), 99999)
    eventPlayer.mauga_berserker_soul = false

rule "[Mauga]: Berserker Soul reset":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isInSpawnRoom() == true

    eventPlayer.mauga_berserker_soul = false

rule "[Mauga]: Berserker Soul Ability":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.mauga_berserker_soul == true

    eventPlayer.dmg_amplification = MaugaBuff[2]
    eventPlayer.dmg_reduction = MaugaBuff[1]
    playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.WHITE, eventPlayer, 200)
    eventPlayer.setStatusEffect(null, Status.UNKILLABLE, 6)
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1.2)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 0.2)
    eventPlayer.setDamageDealt(100 + eventPlayer.dmg_amplification)
    eventPlayer.setDamageReceived(100 - eventPlayer.dmg_reduction)
    eventPlayer.setHealingDealt(0)
    eventPlayer.setHealingReceived(0)
    eventPlayer.setKnockbackReceived(100 - MaugaBuff[5])
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.getMaxHealth() * MaugaBuff[0], true, false)
    eventPlayer.mauga_berserker_soul_id[0] = getLastCreatedHealthPool()
    wait(0.16)
    eventPlayer.setHealth(eventPlayer.getMaxHealth())
    wait(0.16)
    eventPlayer.startDamageOverTime(null, 9999, eventPlayer.getMaxHealth() * MaugaBuff[6])
    eventPlayer.mauga_berserker_soul_id[1] = getLastDamageOverTimeId()
    waitUntil(not eventPlayer.mauga_berserker_soul or eventPlayer.isDead(), 9999)
    eventPlayer.dmg_amplification = 0
    eventPlayer.dmg_reduction = 0
    stopDamageOverTime(eventPlayer.mauga_berserker_soul_id[1])
    removeHealthPool(eventPlayer.mauga_berserker_soul_id[0])
    eventPlayer.setHealingDealt(100)
    eventPlayer.setHealingReceived(100)
    eventPlayer.setDamageDealt(100)
    eventPlayer.setDamageReceived(100)
    eventPlayer.setKnockbackReceived(100)
    eventPlayer.mauga_berserker_soul_id = null
    #eventPlayer.mauga_berserker_soul = false

rule "[Mauga]: Berserker Soul kill to heal":
    @Event playerDealtFinalBlow
    @Hero mauga
    @Condition eventPlayer.mauga_berserker_soul == true

    eventPlayer.setHealth(eventPlayer.getMaxHealth() * MaugaBuff[7] + eventPlayer.getHealth())
    wait(0.5)

rule "[Mauga]: Berserker Soul cd":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.mauga_berserker_soul == true
    #@Condition (eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 2 or eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 2) == true
    @Condition (eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 2 or eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 2) == true

    if eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 2:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 2)
    else:
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, 2)
    wait(1.96)
    if ruleCondition:
        loop()

rule "[Mauga]: fly":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true

    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()
