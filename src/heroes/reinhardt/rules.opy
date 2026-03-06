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
#!include "shield-slam-and-overhealth.opy"
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
