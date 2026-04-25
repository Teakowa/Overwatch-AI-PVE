#!optimizeStrict

rule "[Wuyang]: xuanwu cd":
    @Event playerDealtKnockback
    @Hero wuyang
    @Condition eventAbility == null
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 1)
    wait(0.5)

rule "[Wuyang]: Rushing Torrent":
    @Event eachPlayer
    @Hero wuyang
    @Condition eventPlayer.isUsingAbility1() == true
    

    if eventPlayer.getNormalizedHealth() == 1:
        goto lbl_0
    eventPlayer.startHealingOverTime(eventPlayer, 4.5, WuyangBuff[2])
    eventPlayer.wuyang_buff[0] = getLastHealingOverTimeId()
    lbl_0:
    eventPlayer.dmg_reduction = WuyangBuff[3]
    eventPlayer.setDamageReceived(100 - eventPlayer.dmg_reduction)
    waitUntil(not eventPlayer.isUsingAbility1(), 4.5)
    eventPlayer.dmg_reduction = 0
    stopHealingOverTime(eventPlayer.wuyang_buff[0])
    eventPlayer.setDamageReceived(100)


rule "[Wuyang]: Rushing Torrent jump":
    @Event eachPlayer
    @Hero wuyang
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    #@Condition eventPlayer.isInAir() != true
    @Disabled

    eventPlayer.applyImpulse(Vector.UP, 12, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.16)
    waitUntil(eventPlayer.isOnGround(), 3)

rule "[Wuyang]: Ebb and Flow set":
    @Event playerReceivedKnockback
    #@Condition eventPlayer.isUsingAbility2() == true
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker.getHero() == Hero.WUYANG

    victim.wuyang_buff[2]++
    #eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 1)
    wait(0.16)

rule "[Wuyang]: Ebb and Flow Ability":
    @Event eachPlayer
    @Condition eventPlayer.wuyang_buff[2] >= 2

    eventPlayer.setStatusEffect(eventPlayer.reset_pvar[14], Status.FROZEN, 2.5)
    waitUntil(eventPlayer.unaffected or eventPlayer.hasStatus(Status.INVINCIBLE) or eventPlayer.hasStatus(Status.PHASED_OUT), 5)
    eventPlayer.wuyang_buff[2] *= 0

rule "[Wuyang]: Ebb and Flow countdown":
    @Event eachPlayer
    @Condition eventPlayer.wuyang_buff[2] > 0

    wait(2.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.wuyang_buff[2]--
    if ruleCondition:
        loop()
    #wait(0.25, Wait.RESTART_WHEN_TRUE)

rule "[Wuyang]: Tidal Blast Allies Target":
    @Event playerDealtHealing
    @Hero wuyang
    @Condition eventAbility == Button.ULTIMATE

    eventPlayer.startHealingOverTime(healee, 1.25, eventPlayer.getMaxHealth() * 0.5 / 1.25)

rule "[Wuyang]: Tidal Blast Allies Healing":
    @Event eachPlayer
    @Condition eventPlayer.wuyang_buff == true
    @Disabled

    eventPlayer.startHealingOverTime(eventPlayer.reset_pvar[13], 3, eventPlayer.getMaxHealth() * WuyangBuff[5])
    wait(3)
    eventPlayer.wuyang_buff = false

