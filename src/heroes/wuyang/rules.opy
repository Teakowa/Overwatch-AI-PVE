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
#!include "xuanwu-cd.opy"
rule "[Wuyang]: Restorative shield Target":
    @Event playerReceivedHealing
    @Condition healer.getHero() == Hero.WUYANG
    @Condition eventAbility == null
    @Condition eventHealing <= 8
    @Condition healee.wuyang_buff[0] != true
    
    healee.wuyang_buff[0] = true
    wait(5)
    removeHealthPool(eventPlayer.wuyang_buff[1])
    eventPlayer.wuyang_buff[0] = false
rule "[Wuyang]: Restorative shield":
    @Event eachPlayer
    @Condition eventPlayer.wuyang_buff[0] == true
    @Condition eventPlayer.getHero() != Hero.WUYANG
    
    #eventPlayer.wuyang_buff[0] = false
    if eventPlayer.wuyang_buff[1] == null:
        goto lbl_0
    removeHealthPool(eventPlayer.wuyang_buff[1])
    lbl_0:
    eventPlayer.addHealthPool(Health.SHIELDS, WuyangBuff[1], true, false)
    eventPlayer.wuyang_buff[1] = getLastCreatedHealthPool()
#!include "rushing-torrent.opy"
rule "[Wuyang]: Rushing Torrent jump":
    @Event eachPlayer
    @Hero wuyang
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    #@Condition eventPlayer.isInAir() != true
    
    eventPlayer.applyImpulse(Vector.UP, 12, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(WAIT_SHORT_FRAME)
    waitUntil(eventPlayer.isOnGround(), 3)
#!include "ebb-and-flow-lost-control.opy"
rule "[Wuyang]: Ebb and Flow set":
    @Event playerReceivedKnockback
    #@Condition eventPlayer.isUsingAbility2() == true
    @Condition eventAbility == Button.ABILITY_2
    @Condition attacker.getHero() == Hero.WUYANG
    
    victim.wuyang_buff[2]++
    #eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) - 1)
    wait(WAIT_SHORT_FRAME)
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
rule "[Wuyang]: Tidal Blast mov_speed_penalty":
    @Event playerDealtKnockback
    @Hero wuyang
    @Condition eventAbility == Button.ULTIMATE
    
    if victim.wuyang_buff[4] == true:
        goto lbl_0
    victim.wuyang_buff[4] = true
    if abs(victim.mov_speed_buff) < WuyangBuff[4]:
        victim.mov_speed_buff = -WuyangBuff[4]
        victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
    wait(3)
    if victim.wuyang_buff[4] != true:
        goto lbl_0
    if victim.mov_speed_buff == -WuyangBuff[4]:
        victim.mov_speed_buff = 0
        victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
    victim.wuyang_buff[4] = false
    lbl_0:
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
