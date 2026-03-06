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
