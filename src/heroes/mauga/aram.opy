# mauga aram-mode overlay
#!include "60-berserker-soul-reset.opy"
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
    #@Condition any([i >= 2 for i in [eventPlayer.getAbilityCooldown(Button.ABILITY_1), eventPlayer.getAbilityCooldown(Button.ABILITY_2)]]) == true
    @Condition (eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 2 or eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 2) == true
    
    if eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 2:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 2)
    else:
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, 2)
    wait(1.96)
    if ruleCondition:
        loop()
