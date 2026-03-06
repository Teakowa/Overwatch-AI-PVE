rule "[Mauga] Overrun knockdown duration":
    @Event playerDealtDamage
    @Hero mauga
    @Condition eventAbility == Button.ABILITY_1
    
    victim.setStatusEffect(attacker, Status.BURNING, 2)
    if not victim.hasStatus(Status.KNOCKED_DOWN):
        goto lbl_0
    victim.setStatusEffect(attacker, Status.KNOCKED_DOWN, 2)
    if victim.hasStatus(Status.INVINCIBLE) or victim.hasStatus(Status.UNKILLABLE) or victim.hasStatus(Status.PHASED_OUT) or victim.has_nano:
        goto lbl_1
    damage(victim, attacker, ceil(victim.getMaxHealth() * MaugaBuff[3]))
    lbl_0:
    lbl_1:
rule "[Mauga]: Fortify provides 100 temporary armor":
    @Event eachPlayer
    @Hero mauga
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.unaffected = true
    waitUntil(not eventPlayer.isUsingAbility1(), 3)
    eventPlayer.unaffected = false
rule "[Mauga]: Cardiac Overdrive Dmg. reduction":
    @Event eachPlayer
    @Hero mauga
    @Condition evalOnce(MaugaBuff[4]) != 0
    @Condition eventPlayer.mauga_berserker_soul != true
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.dmg_reduction >= 0
    
    eventPlayer.dmg_reduction = eventPlayer.dmg_reduction if eventPlayer.dmg_reduction > MaugaBuff[4] else MaugaBuff[4]
    eventPlayer.setDamageReceived(100 - eventPlayer.dmg_reduction)
    waitUntil(not eventPlayer.isUsingAbility2(), 3)
    eventPlayer.dmg_reduction -= MaugaBuff[4]
    eventPlayer.setDamageReceived(100)
rule "[Mauga]: Cage Fight ignore headshot":
    @Event eachPlayer
    @Team 1
    @Hero mauga
    @Condition eventPlayer.isUsingUltimate() == true
    
    eventPlayer.startHealingOverTime(eventPlayer, 50, 15)
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
#!include "60-berserker-soul-reset.opy"
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
