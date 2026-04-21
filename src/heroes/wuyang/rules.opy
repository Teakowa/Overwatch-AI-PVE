rule "[Wuyang]: mov_speed_penalty":
    @Event playerDealtKnockback
    @Hero wuyang
    #@Condition eventAbility == null

    if victim.mov_speed_buff < 0 and victim.isAlive():
        victim.setHealth(victim.getHealth() - 50)
        damage(victim, attacker, 25)
    else:
        if victim.wuyang_buff[3] == true:
            goto lbl_0
        victim.wuyang_buff[3] = true
        if abs(victim.mov_speed_buff) < WuyangBuff[0]:
            victim.mov_speed_buff = -WuyangBuff[0]
            victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
        wait(1.25)
        if victim.wuyang_buff[3] != true:
            goto lbl_0
        if victim.mov_speed_buff == -WuyangBuff[0]:
            victim.mov_speed_buff = 0
            victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
        victim.wuyang_buff[3] = false
        lbl_0:
    wait(0.32)

rule "[Wuyang]: xuanwu cd":
    @Event playerDealtKnockback
    @Hero wuyang
    @Condition eventAbility == null
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0

    eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 1)
    wait(0.5)

rule "[Wuyang]: Restorative shield Target":
    @Event playerReceivedHealing
    @Condition healer.getHero() == Hero.WUYANG
    @Condition eventAbility == null
    @Condition eventHealing <= 8
    @Condition healee.wuyang_buff[0] != true
    @Disabled

    healee.wuyang_buff[0] = true
    wait(5)
    removeHealthPool(eventPlayer.wuyang_buff[1])
    eventPlayer.wuyang_buff[0] = false

rule "[Wuyang]: Restorative shield":
    @Event eachPlayer
    @Condition eventPlayer.wuyang_buff[0] == true
    @Condition eventPlayer.getHero() != Hero.WUYANG
    @Disabled

    #eventPlayer.wuyang_buff[0] = false
    if eventPlayer.wuyang_buff[1] == null:
        goto lbl_0
    removeHealthPool(eventPlayer.wuyang_buff[1])
    lbl_0:
    eventPlayer.addHealthPool(Health.SHIELDS, WuyangBuff[1], true, false)
    eventPlayer.wuyang_buff[1] = getLastCreatedHealthPool()

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

rule "[Wuyang]: Tidal Blast Allies Healing":
    @Event eachPlayer
    @Condition eventPlayer.wuyang_buff == true
    @Disabled

    eventPlayer.startHealingOverTime(eventPlayer.reset_pvar[13], 3, eventPlayer.getMaxHealth() * WuyangBuff[5])
    wait(3)
    eventPlayer.wuyang_buff = false
#!include "ability1.opy"
#!include "ability2.opy"
#!include "ultimate.opy"
