# wuyang aram-mode overlay
#!include "shared/20-xuanwu-cd.opy"
#!include "shared/50-rushing-torrent.opy"
#!include "shared/70-ebb-and-flow-lost-control.opy"
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

rule "[Wuyang]: mov_speed_penalty":
    @Event playerDealtKnockback
    @Hero wuyang
    #@Condition eventAbility == null
    
    if victim.mov_speed_penalty > 0 and victim.isAlive():
        victim.setHealth(victim.getHealth() - 45)
    else:
        victim.mov_speed_penalty = WuyangBuff[0]
        victim.setMoveSpeed(100 + victim.mov_speed_buff - victim.mov_speed_penalty)
        waitUntil(victim.mov_speed_penalty == 0 or victim.unaffected or victim.hasStatus(Status.INVINCIBLE), 1.25)
        victim.setMoveSpeed(100)
        victim.mov_speed_penalty = 0
    wait(0.32)

rule "[Wuyang]: Restorative shield Target":
    @Event playerReceivedHealing
    @Condition healer.getHero() == Hero.WUYANG
    @Condition eventAbility == null
    @Condition eventHealing <= 8
    @Condition healee.wuyang_buff[0] != true
    
    healee.wuyang_buff[0] = true
    wait(1)
    removeHealthPool(eventPlayer.wuyang_buff[1])

rule "[Wuyang]: Restorative shield":
    @Event eachPlayer
    @Condition eventPlayer.wuyang_buff[0] == true
    @Condition eventPlayer.getHero() != Hero.WUYANG
    
    eventPlayer.wuyang_buff[0] = false
    if eventPlayer.wuyang_buff[1] == null:
        goto lbl_0
    removeHealthPool(eventPlayer.wuyang_buff[1])
    lbl_0:
    eventPlayer.addHealthPool(Health.SHIELDS, WuyangBuff[1], true, false)
    eventPlayer.wuyang_buff[1] = getLastCreatedHealthPool()

rule "[Wuyang]: Rushing Torrent jump":
    @Event eachPlayer
    @Hero wuyang
    @Condition eventPlayer.isUsingAbility1() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    #@Condition eventPlayer.isInAir() != true
    
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

rule "[Wuyang]: Tidal Blast mov_speed_penalty":
    @Event playerDealtKnockback
    @Hero wuyang
    @Condition eventAbility == Button.ULTIMATE
    
    victim.mov_speed_penalty += WuyangBuff[4]
    victim.setMoveSpeed(100 + victim.mov_speed_buff - victim.mov_speed_penalty)
    waitUntil(victim.mov_speed_penalty == 0 or victim.unaffected or victim.hasStatus(Status.INVINCIBLE), 3)
    victim.setMoveSpeed(100)
    victim.mov_speed_penalty -= WuyangBuff[4]
