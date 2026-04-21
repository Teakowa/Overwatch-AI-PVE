rule "[Soldier: 76]: HeartSteel":
    @Event eachPlayer
    @Team 2
    @Hero soldier
    @Condition any([isInSetup(), isGameInProgress()]) == true
    @Condition S76Buff[1] != 0
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getSpeed() != 0
    @Condition eventPlayer.getMaxHealth() < S76Buff[2]

    wait(S76Buff[0], Wait.ABORT_WHEN_FALSE)
    #heart_steel_hp_id
    if eventPlayer.heart_steel[0] == null:
        goto lbl_0
    removeHealthPool(eventPlayer.heart_steel[0])
    lbl_0:
    if eventPlayer.getMaxHealth() > S76Buff[2]:
        goto lbl_1
    #heart_steel_hp
    eventPlayer.heart_steel[1] += S76Buff[1] + (eventPlayer.getSpeed() - 5.5)
    #heart_steel_hp_lost
    lbl_1:
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.heart_steel[1], true, false)
    smallMessage(eventPlayer, "  心之钢 {0} {1}".format(iconString(Icon.PLUS), S76Buff[1]))
    eventPlayer.heart_steel[0] = getLastCreatedHealthPool()
    if ruleCondition:
        wait(0.016, Wait.ABORT_WHEN_FALSE)
        loop()

rule "[Soldier: 76]: HeartSteel":
    @Event eachPlayer
    @Team 1
    @Hero soldier
    @Condition S76Buff[1] != 0
    @Condition eventPlayer.isAlive() == true

    wait(S76Buff[0], Wait.ABORT_WHEN_FALSE)
    #heart_steel_hp_id
    if eventPlayer.heart_steel[0] == null:
        goto lbl_0
    removeHealthPool(eventPlayer.heart_steel[0])
    lbl_0:
    if eventPlayer.getMaxHealth() >= S76Buff[2]:
        goto lbl_1
    #heart_steel_hp
    eventPlayer.heart_steel[1] += S76Buff[1] + (eventPlayer.getSpeed() - 5.5)
    #heart_steel_hp_lost
    lbl_1:
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.heart_steel[1], true, false)
    smallMessage(eventPlayer, "  心之钢 {0} {1}".format(iconString(Icon.PLUS), S76Buff[1]))
    eventPlayer.heart_steel[0] = getLastCreatedHealthPool()
    if ruleCondition:
        wait(0.016, Wait.ABORT_WHEN_FALSE)
        loop()

rule "[Soldier: 76]: 燃烧":
    @Event eachPlayer
    @Team 2
    @Hero soldier
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition S76Buff[3] != 0
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getSpeed() != 0
    @Condition (len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2])) > 0

    wait(0.016, Wait.ABORT_WHEN_FALSE)
    ([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2]).setStatusEffect(eventPlayer, Status.BURNING, 2)
    ([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2]).startDamageOverTime(eventPlayer, 2, eventPlayer.getMaxHealth() * S76Buff[3])
    wait(1.9)
    if ruleCondition:
        loop()

rule "[Soldier: 76]: 燃烧":
    @Event eachPlayer
    @Team 1
    @Hero soldier
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition S76Buff[3] != 0
    @Condition eventPlayer.isAlive() == true
    @Condition (len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2])) > 0

    wait(0.016, Wait.ABORT_WHEN_FALSE)
    ([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2]).setStatusEffect(eventPlayer, Status.BURNING, 2)
    ([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2]).startDamageOverTime(eventPlayer, 2, eventPlayer.getMaxHealth() * S76Buff[3])
    wait(1.9)
    if ruleCondition:
        loop()

rule "[Soldier: 76]: 治疗":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isAlive() == true

    wait(0.16, Wait.ABORT_WHEN_FALSE)
    eventPlayer.startHealingOverTime(eventPlayer, 5, eventPlayer.getMaxHealth() * 0.1)

rule "[Soldier: 76]: 替代射击":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.dmg_amplification += 300
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setDamageDealt(100 + eventPlayer.dmg_amplification)
    waitUntil(not eventPlayer.isUsingUltimate() or eventPlayer.reset_pvar[0] != false, 8)
    eventPlayer.setDamageDealt(100)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.setPrimaryFireEnabled(true)

rule "[Soldier: 76]: 替代射击":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isFiringSecondaryFire() == true

    waitUntil(not eventPlayer.isFiringSecondaryFire(), 0.496)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0.16)

rule "[Soldier: 76]: Third Person":
    @Event eachPlayer
    @Team 2
    @Hero soldier
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true

    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.third_person = false if eventPlayer.third_person == true else true
    setThirdPerson()

rule "[Soldier: 76]: HeartSteel":
    @Event eachPlayer
    @Team 2
    @Hero soldier
    @Condition any([isInSetup(), isGameInProgress()]) == true
    @Condition S76Buff[1] != 0
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getSpeed() != 0
    @Condition eventPlayer.getMaxHealth() < S76Buff[2]

    wait(S76Buff[0], Wait.ABORT_WHEN_FALSE)
    #heart_steel_hp_id
    if eventPlayer.heart_steel[0] == null:
        goto lbl_0
    removeHealthPool(eventPlayer.heart_steel[0])
    lbl_0:
    if eventPlayer.getMaxHealth() > S76Buff[2]:
        goto lbl_1
    #heart_steel_hp
    eventPlayer.heart_steel[1] += S76Buff[1] + (eventPlayer.getSpeed() - 5.5)
    #heart_steel_hp_lost
    lbl_1:
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.heart_steel[1], true, false)
    smallMessage(eventPlayer, "  心之钢 {0} {1}".format(iconString(Icon.PLUS), S76Buff[1]))
    eventPlayer.heart_steel[0] = getLastCreatedHealthPool()
    if ruleCondition:
        wait(0.016, Wait.ABORT_WHEN_FALSE)
        loop()

rule "[Soldier: 76]: HeartSteel":
    @Event eachPlayer
    @Team 1
    @Hero soldier
    @Condition S76Buff[1] != 0
    @Condition eventPlayer.isAlive() == true

    wait(S76Buff[0], Wait.ABORT_WHEN_FALSE)
    #heart_steel_hp_id
    if eventPlayer.heart_steel[0] == null:
        goto lbl_0
    removeHealthPool(eventPlayer.heart_steel[0])
    lbl_0:
    if eventPlayer.getMaxHealth() >= S76Buff[2]:
        goto lbl_1
    #heart_steel_hp
    eventPlayer.heart_steel[1] += S76Buff[1] + (eventPlayer.getSpeed() - 5.5)
    #heart_steel_hp_lost
    lbl_1:
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.heart_steel[1], true, false)
    smallMessage(eventPlayer, "  心之钢 {0} {1}".format(iconString(Icon.PLUS), S76Buff[1]))
    eventPlayer.heart_steel[0] = getLastCreatedHealthPool()
    if ruleCondition:
        wait(0.016, Wait.ABORT_WHEN_FALSE)
        loop()

rule "[Soldier: 76]: 燃烧":
    @Event eachPlayer
    @Team 2
    @Hero soldier
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition S76Buff[3] != 0
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getSpeed() != 0
    @Condition (len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2])) > 0

    wait(0.016, Wait.ABORT_WHEN_FALSE)
    ([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2]).setStatusEffect(eventPlayer, Status.BURNING, 2)
    ([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2]).startDamageOverTime(eventPlayer, 2, eventPlayer.getMaxHealth() * S76Buff[3])
    wait(1.9)
    if ruleCondition:
        loop()

rule "[Soldier: 76]: 燃烧":
    @Event eachPlayer
    @Team 1
    @Hero soldier
    @Condition eventPlayer.isUsingUltimate() != true
    @Condition S76Buff[3] != 0
    @Condition eventPlayer.isAlive() == true
    @Condition (len([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2])) > 0

    wait(0.016, Wait.ABORT_WHEN_FALSE)
    ([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2]).setStatusEffect(eventPlayer, Status.BURNING, 2)
    ([player for player in getLivingPlayers(getOppositeTeam(eventPlayer.getTeam())) if isInLoS(eventPlayer, player, BarrierLos.BLOCKED_BY_ENEMY_BARRIERS) and distance(eventPlayer, player) <= S76Buff[4] and not player.hasStatus(Status.INVINCIBLE) and player.getPosition().y - eventPlayer.getPosition().y <= 2]).startDamageOverTime(eventPlayer, 2, eventPlayer.getMaxHealth() * S76Buff[3])
    wait(1.9)
    if ruleCondition:
        loop()

rule "[Soldier: 76]: 治疗":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isAlive() == true

    wait(0.16, Wait.ABORT_WHEN_FALSE)
    eventPlayer.startHealingOverTime(eventPlayer, 5, eventPlayer.getMaxHealth() * 0.1)

rule "[Soldier: 76]: 替代射击":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingUltimate() == true

    eventPlayer.dmg_amplification += 300
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setDamageDealt(100 + eventPlayer.dmg_amplification)
    waitUntil(not eventPlayer.isUsingUltimate() or eventPlayer.reset_pvar[0] != false, 8)
    eventPlayer.setDamageDealt(100)
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.setPrimaryFireEnabled(true)

rule "[Soldier: 76]: 替代射击":
    @Event eachPlayer
    @Hero soldier
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingUltimate() == true
    @Condition eventPlayer.isFiringSecondaryFire() == true

    waitUntil(not eventPlayer.isFiringSecondaryFire(), 0.496)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0.16)
