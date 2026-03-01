rule "[Mauga]: Berserker Soul status active":
    @Event playerTookDamage
    @Hero mauga
    #@Condition eventDamage > eventPlayer.getHealth() + 25
    @Condition eventPlayer.mauga_berserker_soul != true
    @Condition eventPlayer.getHealth() <= 75
    
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
    eventPlayer.dmg_reduction = eventPlayer.dmg_reduction if eventPlayer.dmg_reduction > MaugaBuff[1] else MaugaBuff[1]
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
    wait(WAIT_SHORT_FRAME)
    eventPlayer.setHealth(eventPlayer.getMaxHealth())
    wait(WAIT_SHORT_FRAME)
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
    @Event playerEarnedElimination
    @Hero mauga
    @Condition eventPlayer.mauga_berserker_soul == true
    
    eventPlayer.setHealth(eventPlayer.getMaxHealth() * MaugaBuff[7] + eventPlayer.getHealth())
    wait(0.5)


rule "[Mauga]: Berserker Soul cd":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.mauga_berserker_soul == true
    #@Condition any([eventPlayer.getAbilityCooldown(i) >= 2 for i in [eventPlayer.getAbilityCooldown(Button.ABILITY_1), eventPlayer.getAbilityCooldown(Button.ABILITY_2)]]) == true
    @Condition (eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 2 or eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 2) == true
    
    if eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 2:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 2)
    else:
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, 2)
    wait(1.96)
    if ruleCondition:
        loop()


rule "[Reaper]: Wraith Form to fly":
    @Event eachPlayer
    @Hero reaper
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.applyImpulse(Vector.UP, 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    loop()


rule "[Reaper]: Wraith Form to fly":
    @Event eachPlayer
    @Hero reaper
    @Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    
    eventPlayer.applyImpulse(Vector.DOWN, 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.1, Wait.ABORT_WHEN_FALSE)
    loop()


rule "[Reaper]: kill to gain soul buff":
    @Event playerEarnedElimination
    @Hero reaper
    #@Condition eventPlayer.reaper_buff[0] < 50
    @Condition ReaperBuff[0] != 0
    
    eventPlayer.reaper_buff[0] += ReaperBuff[0] + 1 if eventPlayer.getTeam() == Team.1 else ReaperBuff[0]


rule "[Reaper]: kill to gain soul buff":
    @Event playerDealtFinalBlow
    @Hero reaper
    #@Condition eventPlayer.reaper_buff[0] < 50
    
    eventPlayer.reaper_buff[0] += ReaperBuff[0] + 1 if eventPlayer.getTeam() == Team.1 else ReaperBuff[0]


rule "[Reaper]: Ability 1 Wraith Form cd":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility1() == true
    
    waitUntil(not eventPlayer.isUsingAbility1(), 3.016)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) - (50 * ReaperBuff[1] if eventPlayer.reaper_buff[0] > 50 else eventPlayer.reaper_buff[0] * ReaperBuff[1]))
    eventPlayer.dmg_amplification += 150 if ReaperBuff[2] + eventPlayer.reaper_buff[0] * ReaperBuff[3] >= 150 else ReaperBuff[2] + eventPlayer.reaper_buff[0] * ReaperBuff[3]
    wait(3)
    #chaseOverTime(eventPlayer.dmg_amplification, 0, 3, ChaseTimeReeval.NONE)
    eventPlayer.dmg_amplification = 0


rule "[Reaper]: Ability 2 Shadow Step cd":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility2() == true
    
    waitUntil(not eventPlayer.isUsingAbility2(), 3.016)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - (50 * ReaperBuff[1] if eventPlayer.reaper_buff[0] > 50 else eventPlayer.reaper_buff[0] * ReaperBuff[1]))
    eventPlayer.dmg_reduction += 60 if ReaperBuff[4] + eventPlayer.reaper_buff[0] * ReaperBuff[5] >= 60 else ReaperBuff[4] + eventPlayer.reaper_buff[0] * ReaperBuff[5]


rule "[Reaper]: Ability 1 Wraith Form dmg increase setup":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.dmg_amplification != 0
    
    eventPlayer.setDamageDealt(100 + eventPlayer.dmg_amplification)
    wait(0.5)
    eventPlayer.dmg_amplification -= eventPlayer.dmg_amplification * 0.3
    if ruleCondition:
        loop()
    eventPlayer.setDamageDealt(100)


rule "[Reaper]: Ability 1 Wraith Form dmg increase set & hud":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.dmg_amplification != 0
    
    destroyHudText(eventPlayer.reaper_buff[1])
    hudText(eventPlayer, null, " \r\n", "伤害增幅：{0}%".format(ceil(eventPlayer.dmg_amplification)), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.reaper_buff[1] = getLastCreatedText()
    waitUntil(eventPlayer.dmg_amplification == 0 and eventPlayer.isDead(), 3.5)
    destroyHudText(eventPlayer.reaper_buff[1])
    eventPlayer.reaper_buff[1] = 0


rule "[Reaper]: Ability 2 Shadow Step dmg reduction setup":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingAbility2() != true
    @Condition eventPlayer.dmg_reduction != 0
    
    destroyHudText(eventPlayer.reaper_buff[1])
    hudText(eventPlayer, null, " \r\n", "受到伤害减免：{0}%".format(ceil(eventPlayer.dmg_reduction)), HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.reaper_buff[1] = getLastCreatedText()
    eventPlayer.setDamageReceived(100 - eventPlayer.dmg_reduction)
    wait(5)
    eventPlayer.dmg_reduction = 0
    eventPlayer.setDamageReceived(100)
    destroyHudText(eventPlayer.reaper_buff[1])
    eventPlayer.reaper_buff[1] = 0


rule "[Reaper]: Ability Dire Triggers":
    @Event eachPlayer
    @Hero reaper
    #@Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 1.5
    @Condition eventPlayer.isFiringSecondaryFire() == true
    
    waitUntil(not eventPlayer.isFiringSecondaryFire(), 0.6)
    eventPlayer.setAmmo(0, eventPlayer.getAmmo() + 1)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, ReaperBuff[6])


rule "[Reaper]: Ability Dire Triggers dot":
    @Event playerDealtDamage
    @Hero reaper
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    #wait(WAIT_SHORT_FRAME)
    victim.startDamageOverTime(attacker, 1, eventPlayer.reaper_buff[0] * ReaperBuff[7])
    #victim.reaper_buff = getLastDamageOverTimeId()
    #wait(1)
    #victim.reaper_buff = 0


rule "[Reaper]: ultimate Death Blossom":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setDamageDealt(100 + eventPlayer.reaper_buff[0] * ReaperBuff[8])
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setStatusEffect(eventPlayer, Status.UNKILLABLE, 2.5 if eventPlayer.reaper_buff[0] * 0.05 >= 2.5 else eventPlayer.reaper_buff[0] * 0.05)
    waitUntil(not eventPlayer.isUsingUltimate(), 3.016)
    eventPlayer.setDamageDealt(100)


rule "[Reaper]: HUD & Reset":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.reset_pvar[0] == false
    @Condition eventPlayer.reaper_buff[0] > 0
    
    if eventPlayer.reaper_buff[2] != 0:
        goto lbl_0
    hudText(eventPlayer, null, " \r\n\r\n\n", "已收割灵魂： {0}".format(eventPlayer.reaper_buff[0]), HudPosition.LEFT, 3, null, null, rgb(255, 255, 255, 200), HudReeval.STRING)
    eventPlayer.reaper_buff[2] = getLastCreatedText()
    lbl_0:
    waitUntil(eventPlayer.reaper_buff[0] == 0 or eventPlayer.reset_pvar[0], WAIT_TIMEOUT_FOREVER)
    destroyHudText(eventPlayer.reaper_buff[2])
    eventPlayer.reaper_buff[2] = 0


rule "[Echo]: Focusing Beam Damage":
    @Event eachPlayer
    @Hero echo
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isUsingAbility2() == true
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setDamageDealt(150)
    waitUntil(not eventPlayer.isUsingAbility2(), 2)
    eventPlayer.setDamageDealt(100)


rule "[Moira]: Fade disable on Coalescence":
    @Event eachPlayer
    @Hero moira
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.disallowButton(Button.ABILITY_1)
    waitUntil(not eventPlayer.isUsingUltimate(), 9)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.setAbility1Enabled(true)


rule "[Moira]: Abilities to heal self":
    @Event eachPlayer
    @Hero moira
    @Condition any([eventPlayer.isUsingAbility1(), eventPlayer.getAbilityCooldown(Button.ABILITY_2) >= 7.5, eventPlayer.isUsingUltimate()]) == true
    @Condition eventPlayer.getNormalizedHealth() < 1
    
    eventPlayer.startHealingOverTime(eventPlayer, 0.6, 0.75 * (eventPlayer.getMaxHealth() - eventPlayer.getHealth()))
    wait(WAIT_SHORT_FRAME)


rule "[Zarya]: will to win":
    @Event eachPlayer
    @Hero zarya
    @Condition eventPlayer.reset_pvar[0] == false
    @Condition eventPlayer.isInSpawnRoom() != true
    @Condition eventPlayer.getHero() == Hero.ZARYA
    @Condition ZaryaBuff[2] == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.zarya_buff[0] == true
    @Condition eventPlayer.getHealth() <= eventPlayer.getMaxHealth() * 0.3
    
    bigMessage(eventPlayer, "胜利意志！")
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 1)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    eventPlayer.startHealingOverTime(eventPlayer, ZaryaBuff[3], ZaryaBuff[4])
    eventPlayer.zarya_buff[1] = getLastHealingOverTimeId()
    waitUntil(eventPlayer.isDead(), ZaryaBuff[3])
    stopHealingOverTime(eventPlayer.zarya_buff[1])
    eventPlayer.zarya_buff[0] = false
    eventPlayer.zarya_buff[1] = null


rule "[Reaper]: Death Blossom remove Mov. speed penalty":
    @Event eachPlayer
    @Hero reaper
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.mov_speed_buff += 100
    eventPlayer.setMoveSpeed(100 + eventPlayer.mov_speed_buff)
    waitUntil(not eventPlayer.isUsingUltimate(), 3.5)
    eventPlayer.mov_speed_buff = 0
    eventPlayer.setMoveSpeed(100)


