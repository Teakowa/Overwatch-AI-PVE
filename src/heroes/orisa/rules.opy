#!include "fortify-ricochet-damage.opy"
rule "[Orisa]: Fortify provides 100 temporary armor":
    @Event eachPlayer
    @Hero orisa
    @Condition Orisa_Fortify[0] != 0
    #@Condition (eventPlayer.isUsingAbility1() or eventPlayer.isUsingUltimate()) == true
    @Condition any([i == true for i in [eventPlayer.isUsingAbility1(), eventPlayer.isUsingUltimate()]]) == true
    
    eventPlayer.unaffected = true
    wait(0.096, Wait.ABORT_WHEN_FALSE)
    clearMoveSpeedDebuffs()
    eventPlayer.addHealthPool(Health.ARMOR, Orisa_Fortify[0], true, false)
    eventPlayer.orisa_fortify_armor_id = getLastCreatedHealthPool()
    if eventPlayer.isUsingAbility1() == true:
        waitUntil(not eventPlayer.isUsingAbility1(), Math.INFINITY)
    else:
        waitUntil(not eventPlayer.isUsingUltimate(), Math.INFINITY)
    removeHealthPool(eventPlayer.orisa_fortify_armor_id)
    eventPlayer.unaffected = false
rule "[Orisa]: stun when ult":
    @Event playerDealtKnockback
    @Hero orisa
    @Condition eventAbility == Button.ULTIMATE
    @Condition victim.unaffected != true
    
    victim.setStatusEffect(attacker, Status.STUNNED, 1.25)
rule "[Orisa]: stun when ult":
    @Event playerDealtKnockback
    @Hero orisa
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition victim.isAlive() == true
    @Condition victim.unaffected != true
    
    wait(0.3, Wait.ABORT_WHEN_FALSE)
    if victim.zarya_buff[1] != null:
        goto lbl_0
    if victim.orisa_buff == true:
        goto lbl_0
    victim.orisa_buff = true
    if abs(victim.mov_speed_buff) < Orisa_Fortify[2]:
        victim.mov_speed_buff = -Orisa_Fortify[2]
        victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
    wait(2)
    if victim.orisa_buff != true:
        goto lbl_0
    if victim.mov_speed_buff == -Orisa_Fortify[2]:
        victim.mov_speed_buff = 0
        victim.setMoveSpeed(min(max(100 + victim.mov_speed_buff, 20), 200))
    victim.orisa_buff = false
    lbl_0:
rule "[Orisa]: fly":
    @Event eachPlayer
    @Hero orisa
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()
