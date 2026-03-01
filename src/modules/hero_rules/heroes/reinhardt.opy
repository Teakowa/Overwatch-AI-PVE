rule "[Soldier: 76]: Helix Rockets lose control":
    @Event playerDealtDamage
    @Hero soldier
    #@Condition attacker.getHero() == Hero.SOLDIER
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition attacker != victim
    
    #victim.applyImpulse(Vector.BACKWARD, 7, Relativity.TO_PLAYER)
    victim.setStatusEffect(attacker, Status.BURNING, S76Buff[0])
    victim.startDamageOverTime(attacker, S76Buff[0], S76Buff[1])


rule "[Reinhardt] firestrike healing":
    @Event playerDealtDamage
    @Hero reinhardt
    @Condition (eventAbility == Button.ABILITY_2 or eventAbility == Button.ULTIMATE) == true
    
    if eventAbility == Button.ULTIMATE:
        goto lbl_0
    eventPlayer.startHealingOverTime(eventPlayer, 2, eventDamage / 2)
    lbl_0:
    victim.setStatusEffect(attacker, Status.BURNING, 2)
    victim.startDamageOverTime(attacker, 2, 20)


rule "[Reinhardt]: Earthshatter":
    @Event playerDealtFinalBlow
    @Hero reinhardt
    @Condition eventWasCriticalHit == true
    @Condition eventAbility == Button.ULTIMATE
    
    eventPlayer.setUltCharge(100)


rule "[Reinhardt]: Crusaders stand":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.reinhardt_buff[0] == false
    @Condition eventPlayer.getHealthOfType(Health.ARMOR) <= 0
    
    eventPlayer.reinhardt_buff[0] = true


rule "[Reinhardt]: Crusaders stand":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.reinhardt_buff[0] == true
    
    bigMessage(eventPlayer, "  十字军坚定")
    smallMessage(eventPlayer, "  {0} 无视击退".format(abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE)))
    eventPlayer.addHealthPool(Health.NORMAL, 200, false, false)
    eventPlayer.setKnockbackReceived(0)
    waitUntil(not eventPlayer.reinhardt_buff[0], 8)
    eventPlayer.setKnockbackReceived(100)
    wait(30)
    eventPlayer.reinhardt_buff[0] = false
    smallMessage(eventPlayer, "  {0} 十字军坚定 已就绪".format(abilityIconString(eventPlayer.getHero(), Button.SECONDARY_FIRE)))


rule "[Reinhardt]: Charge cd":
    @Event eachPlayer
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility1() == true
    
    wait(0.592, Wait.ABORT_WHEN_FALSE)
    eventPlayer.reinhardt_charge_cd = 3
    chaseOverTime(eventPlayer.reinhardt_charge_cd, 0, 3, ChaseTimeReeval.NONE)
    waitUntil(not eventPlayer.isUsingAbility1() and eventPlayer.getAbilityCooldown(Button.ABILITY_1) >= 6, 3.592)
    if eventPlayer.reinhardt_charge_cd == 0:
        goto lbl_0
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) - eventPlayer.reinhardt_charge_cd)
    lbl_0:


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


rule "[Reinhardt]: Charge dmg fix":
    @Event playerReceivedKnockback
    @Condition attacker.getHero() == Hero.REINHARDT
    @Condition eventAbility == null
    @Condition eventPlayer.getMaxHealth() <= 300
    @Condition eventPlayer.hasStatus(Status.STUNNED) == true
    
    startDamageModification(eventPlayer, attacker, 200, DamageReeval.RECEIVERS_AND_DAMAGERS)
    eventPlayer.rein_charge_fix = getLastDamageModification()
    waitUntil(eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0, 3.12)
    stopDamageModification(eventPlayer.rein_charge_fix)


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


